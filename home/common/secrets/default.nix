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
      mode = "0600";
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
    (map (account: nameValuePair "email-passwords/${account}" { mode = "0600"; }))
    builtins.listToAttrs
  ];

  calendarSecrets = pipe (inputs.trivnixPrivate.calendarAccounts.${userInfos.name} or { }) [
    builtins.attrNames
    (map (account: nameValuePair "calendar-passwords/${account}" { mode = "0600"; }))
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
        git-signing-key.mode = "0600";
      })
    ];
  };
}
