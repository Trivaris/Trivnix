{ inputs, ... }:
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.self}/resources/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed2519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      "user-passwords/trivaris" = { };
      "user-passwords/root" = { };

      "ssh-private-keys/wsl" = { };
      "ssh-private-keys/laptop" = { };
      "ssh-private-keys/desktop" = { };

      "smtp-passwords/public" = { };
      "smtp-passwords/private" = { };
      "smtp-passwords/school" = { };
    };
  };

}
