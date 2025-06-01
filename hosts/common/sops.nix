{
  inputs,
  ...
}:
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./resources/sescrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/user/.config/sops/age/private.txt";

  sops.secrets.ssh-private-key = {
    path = "/home/trivaris/.ssh/id_ed25519";
    owner = "trivaris";
    mode = "0600";
  };
  sops.secrets.root-password = { 
      path = "/root/.pwd";
    owner = "root";
    mode = "0400";
  };
  sops.secrets.trivaris-password = {
    path = "/home/trivaris/.pwd";
    owner = "trivaris";
    mode = "0400";
  };

}