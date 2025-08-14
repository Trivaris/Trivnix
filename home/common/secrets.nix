{
  inputs,
  lib,
  libExtra,
  userInfo,
  hostInfo,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath "/secrets/home/${userInfo.name}/common.yaml";
  hostSecrets = libExtra.mkFlakePath "/secrets/home/${userInfo.name}/${hostInfo.configname}.yaml";

  mkKey = name: {
    ${name} = {
      sopsFile = hostSecrets;
      mode = "0600";
    };
  };

  sshSecrets = lib.mkMerge (
    if hostInfo.hardwareKey then
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

    age.keyFile = "/home/${userInfo.name}/.config/sops/age/key.txt";
    age.generateKey = false;

    secrets = lib.mkMerge [
      sshSecrets
      emailSecrets
      calendarSecrets
    ];
  };
}
