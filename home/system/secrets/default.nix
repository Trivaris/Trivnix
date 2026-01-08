{
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    nameValuePair
    pipe
    ;

  prefs = config.userPrefs;
  commonSecrets = "${config.private.secrets}/home/${userInfos.name}/common.yaml";
  hostSecrets = "${config.private.secrets}/home/${userInfos.name}/${config.hostInfos.configname}.yaml";

  sshSecrets."ssh-private-key" = {
    sopsFile = hostSecrets;
  };

  emailSecrets = pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: nameValuePair "email-passwords/${account}" { }))
    builtins.listToAttrs
  ];

  calendarSecrets = pipe (config.private.calendarAccounts.${userInfos.name} or { }) [
    builtins.attrNames
    (map (account: nameValuePair "calendar-passwords/${account}" { }))
    builtins.listToAttrs
  ];
in
{
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age = {
      keyFile = "/home/${userInfos.name}/.config/sops/age/key.txt";
      generateKey = false;
    };

    secrets = mkMerge [
      sshSecrets
      emailSecrets
      calendarSecrets
      (mkIf prefs.git.enableSigning {
        git-signing-key = { };
      })
    ];
  };
}
