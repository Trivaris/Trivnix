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
  inherit (lib)
    concatMap
    nameValuePair
    attrNames
    filterAttrs
    pipe
    ;

  aliases = builtins.listToAttrs (
    concatMap
      (
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
      )
      (
        pipe allHostPrefs [
          (filterAttrs (_: prefs: prefs.openssh.enable or false))
          attrNames
        ]
      )
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
