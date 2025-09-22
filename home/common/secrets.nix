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
  hasPrivate = inputs ? trivnixPrivate;
  private = if hasPrivate then inputs.trivnixPrivate else { };
  hasEmail = hasPrivate && (private ? emailAccounts) && builtins.isAttrs private.emailAccounts;
  hasCalendar =
    hasPrivate && (private ? calendarAccounts) && builtins.isAttrs private.calendarAccounts;

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

  calendarSecrets = pipe (private.calendarAccounts.${userInfos.name} or { }) [
    builtins.attrNames
    (map (account: nameValuePair "calendar-passwords/${account}" { mode = "0600"; }))
    builtins.listToAttrs
  ];
in
{
  assertions = [
    {
      assertion = hasPrivate;
      message = ''
        Missing input "trivnixPrivate". Provide your private flake or override the input.
        See docs/trivnix-private.md and use: nix build --override-input trivnixPrivate <your_repo>
      '';
    }
    {
      assertion = hasEmail;
      message = ''Invalid or missing inputs.trivnixPrivate.emailAccounts (expected attrset).'';
    }
    {
      assertion = hasCalendar;
      message = ''Invalid or missing inputs.trivnixPrivate.calendarAccounts (expected attrset).'';
    }
  ];

  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/home/${userInfos.name}/.config/sops/age/key.txt";
    age.generateKey = false;

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
