{
  config,
  lib,
  hostInfo,
  userPrefs,
  allHostInfos,
  ...
}:
let
  aliases = builtins.listToAttrs (
    lib.concatMap (
      configname:
      let
        host = allHostInfos.${configname};
      in
      [
        {
          name = host.name;
          value = {
            hostname = host.ip;
            user = userPrefs.name;
          };
        }
      ]
    ) (lib.attrNames (lib.filterAttrs (_: host: host.ip != null) allHostInfos))
  );
in
{

  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile =
          if hostInfo.hardwareKey then
            [
              config.sops.secrets.ssh-private-key-a.path
              config.sops.secrets.ssh-private-key-c.path
            ]
          else
            [
              config.sops.secrets.ssh-private-key.path
            ];
      };
    }
    // aliases;
  };

}
