{
  inputs,
  lib,
  trivnixLib,
  userInfos,
  hostInfos,
  ...
}:
let
  commonSecrets = trivnixLib.mkStorePath "secrets/home/${userInfos.name}/common.yaml";
  hostSecrets = trivnixLib.mkStorePath "secrets/home/${userInfos.name}/${hostInfos.configname}.yaml";

  mkKey = name: {
    ${name} = {
      sopsFile = hostSecrets;
      mode = "0600";
    };
  };

  sshSecrets = lib.mkMerge (
    if hostInfos.hardwareKey then
      [
        (mkKey "ssh-private-key-a")
        (mkKey "ssh-private-key-c")
      ]
    else
      [ (mkKey "ssh-private-key") ]
  );

  emailSecrets = builtins.listToAttrs (
    map (account: {
      name = "email-passwords/${account}";
      value = {
        mode = "0600";
      };
    }) (builtins.attrNames inputs.trivnix-private.emailAccounts)
  );

  calendarSecrets = builtins.listToAttrs (
    map (account: {
      name = "calendar-passwords/${account}";
      value = {
        mode = "0600";
      };
    }) (builtins.attrNames inputs.trivnix-private.calendarAccounts)
  );
in
{
  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/home/${userInfos.name}/.config/sops/age/key.txt";
    age.generateKey = false;

    secrets = lib.mkMerge [
      sshSecrets
      emailSecrets
      calendarSecrets
    ];
  };
}
