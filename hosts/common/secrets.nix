{ inputs, ... }:
{ 
  
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = inputs.self + "/resources/secrets.yaml";
  sops.validateSopsFiles = false;
  sops.defaultSopsFormat = "yaml";
  sops.age = {
    keyFile = "/var/lib/sops-nix/key.txt";
  };

  sops.secrets = {
    ssh-private-key = { };
    trivaris-password = { };
    root-password = { };
  };
  
}