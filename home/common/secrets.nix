{
  inputs,
  username,
  configname,
  libExtra,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath "/secrets/home/${username}/common.yaml";
  hostSecrets = libExtra.mkFlakePath "/secrets/home/${username}/${configname}.yaml";
in
{

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    age.generateKey = false;

    secrets = {

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };

      "ssh-private-key/a" = { 
        sopsFile = hostSecrets;
        mode = "0400";
      };
      "ssh-private-key/c" = { 
        sopsFile = hostSecrets;
        mode = "0400";
      };

    };
  };

}
