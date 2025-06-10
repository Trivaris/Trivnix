{
  inputs,
  username,
  configname,
  ...
}:
{

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = inputs.self + "/resources/secrets.yaml";
    validateSopsFiles = false;

    age = {
      generateKey = true;
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };


    secrets = {
      "ssh-private-keys/${username}/${configname}/key" = {
        path = "/home/${username}/.ssh/id_ed25519";
      };
      "ssh-private-keys/${username}/${configname}/passphrase" = { };

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };
    };
  };

}
