{
  inputs,
  username,
  configname,
  ...
}:
let
  commonSecrets = inputs.self + "/secrets/home/${username}/common.yaml";
  userSecrets = inputs.self + "/secrets/home/${username}/${configname}.yaml";
in
{

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = commonSecrets;
    validateSopsFiles = true;

    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    age.generateKey = false;sudo cat /etc/ssh/ssh_host_ed25519_key

    secrets = {
    
      "user-ssh-key/key" = {
        path = "/home/${username}/.ssh/id_ed25519";
        sopsFile = userSecrets;
      };
      "user-ssh-key/passphrase" = {
        sopsFile = userSecrets;
      };

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };
    
    };
  };

}