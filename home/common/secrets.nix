{
  inputs,
  username,
  configname,
  libExtra,
  ...
}:
let
  commonSecrets = libExtra.mkFlakePath "/secrets/home/${username}/common.yaml";
  userSecrets = libExtra.mkFlakePath "/secrets/home/${username}/${configname}.yaml";
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

      "ssh-user-key/key" = {
        path = "/home/${username}/.ssh/id_ed25519";
        sopsFile = userSecrets;
      };
      "ssh-user-key/passphrase" = {
        sopsFile = userSecrets;
      };

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };

    };
  };

}
