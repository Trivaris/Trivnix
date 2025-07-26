{
  inputs,
  lib,
  libExtra,
  configname,
  userconfig,
  hostconfig,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath "/secrets/home/${userconfig.name}/common.yaml";
  hostSecrets = libExtra.mkFlakePath "/secrets/home/${userconfig.name}/${configname}.yaml";
  
  mkKey = name: {
    ${name} = {
      sopsFile = hostSecrets;
      mode = "0600";
    };
  };

  sshSecrets = lib.mkMerge (
    if hostconfig.hardwareKey then
      [ (mkKey "ssh-private-key-a") (mkKey "ssh-private-key-c") ]
    else
      [ (mkKey "ssh-private-key") ]
  );

  
  emailSecrets = builtins.listToAttrs (map (account: {
    name = "email-passwords/${account}";
    value = { };
  }) (builtins.attrNames inputs.trivnix-private.emailAccounts));
in
{

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/home/${userconfig.name}/.config/sops/age/keys.txt";
    age.generateKey = false;

    secrets = lib.mkMerge [
      sshSecrets
      emailSecrets
    ];
  };

}
