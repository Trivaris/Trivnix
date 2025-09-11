{
  config,
  lib,
  allHostInfos,
  allHostPrefs,
  hostInfos,
  userInfos,
  ...
}:
let
  aliases = builtins.listToAttrs (
    lib.concatMap (
      configname:
      let
        infos = allHostInfos.${configname};
      in
      [
        (lib.nameValuePair infos.name {
          hostname = infos.ip;
          user = userInfos.name;
        })
      ]
    ) (lib.attrNames (lib.filterAttrs (_: prefs: prefs.openssh.enable or false) allHostPrefs))
  );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        addKeysToAgent = "no";
        identityFile =
          if hostInfos.hardwareKey then
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
