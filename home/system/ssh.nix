{
  allHostInfos,
  allHostPrefs,
  config,
  lib,
  userInfos,
  ...
}:
let
  aliases = builtins.listToAttrs (
    lib.concatMap (configname: [
      (lib.nameValuePair allHostInfos.${configname}.name {
        hostname = allHostInfos.${configname}.ip;
        user = userInfos.name;
      })
    ]) (builtins.attrNames (lib.filterAttrs (_: prefs: prefs.openssh.enable or false) allHostPrefs))
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
        identityFile = [
          config.sops.secrets.ssh-private-key.path
        ];
      };
    }
    // aliases;
  };
}
