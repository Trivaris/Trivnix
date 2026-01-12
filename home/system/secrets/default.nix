{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  commonSecrets = "${config.private.secrets}/home/${config.userInfos.name}/common.yaml";
  hostSecrets = "${config.private.secrets}/home/${config.userInfos.name}/${config.hostInfos.configname}.yaml";

  sshSecrets."ssh-private-key" = {
    sopsFile = hostSecrets;
  };

  emailSecrets = lib.pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: lib.nameValuePair "email-passwords/${account}" { }))
    builtins.listToAttrs
  ];

  calendarSecrets = lib.pipe (config.private.calendarAccounts.${config.userInfos.name} or { }) [
    builtins.attrNames
    (map (account: lib.nameValuePair "calendar-passwords/${account}" { }))
    builtins.listToAttrs
  ];
in
{
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age = {
      keyFile = "/home/${config.userInfos.name}/.config/sops/age/key.txt";
      generateKey = false;
    };

    secrets = lib.mkMerge [
      sshSecrets
      emailSecrets
      calendarSecrets
      (lib.mkIf prefs.git.enableSigning {
        git-signing-key = { };
      })
    ];
  };
}
