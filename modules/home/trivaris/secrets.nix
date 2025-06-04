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
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = inputs.self + "/resources/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "ssh-private-keys/${configname}" = {
        path = "/home/${username}/.ssh/id_ed25519";
      };

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };
    };
  };

}
