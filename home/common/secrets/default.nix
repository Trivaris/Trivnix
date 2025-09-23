{
  lib,
  inputs,
  config,
  hostInfos,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkMerge
    nameValuePair
    mkIf
    pipe
    ;

  prefs = config.userPrefs;
  commonSecrets = "${inputs.trivnixPrivate.secrets}/home/${userInfos.name}/common.yaml";
  hostSecrets = "${inputs.trivnixPrivate.secrets}/home/${userInfos.name}/${hostInfos.configname}.yaml";

  mkKey = name: {
    ${name} = {
      sopsFile = hostSecrets;
    };
  };

  sshSecrets = mkMerge (
    if hostInfos.hardwareKey then
      [
        (mkKey "ssh-private-key-a")
        (mkKey "ssh-private-key-c")
      ]
    else
      [ (mkKey "ssh-private-key") ]
  );

  emailSecrets = pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: nameValuePair "email-passwords/${account}" { }))
    builtins.listToAttrs
  ];

  calendarSecrets = pipe (inputs.trivnixPrivate.calendarAccounts.${userInfos.name} or { }) [
    builtins.attrNames
    (map (account: nameValuePair "calendar-passwords/${account}" { }))
    builtins.listToAttrs
  ];
in
{
  assertions = import ./assertions.nix { inherit inputs; };
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
