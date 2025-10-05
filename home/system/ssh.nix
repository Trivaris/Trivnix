{
  allHostInfos,
  allHostPrefs,
  config,
  hostInfos,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) concatMap nameValuePair filterAttrs;
  aliases = builtins.listToAttrs (
    concatMap (
      configname:
      let
        infos = allHostInfos.${configname};
      in
      [
        (nameValuePair infos.name {
          hostname = infos.ip;
          user = userInfos.name;
        })
      ]
    ) (builtins.attrNames (filterAttrs (_: prefs: prefs.openssh.enable or false) allHostPrefs))
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
