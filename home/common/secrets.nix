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
      keyFile = /var/lib/sops-nix/keys.txt;
      generateKey = true;
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };


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
