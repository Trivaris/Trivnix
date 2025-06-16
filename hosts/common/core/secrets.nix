{ inputs, pkgs, usernames, configname, ... }:
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = inputs.self + "/resources/secrets.yaml";
    validateSopsFiles = false;
    
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    secrets =
      builtins.listToAttrs (builtins.map (user: {
        name  = "user-passwords/${user}";
        value = { neededForUsers = true; };
      }) usernames)
      // {
        "ssh-private-keys/hosts/${configname}" = {
          path   = "/etc/ssh/ssh_host_ed25519_key";
          owner  = "root"; group = "root"; mode = "0600";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      };
  };

}
