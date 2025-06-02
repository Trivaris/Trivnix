{ 
  inputs,
  config,
  ... 
}:
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

  programs.git = {
    enable = true;
    userName = "trivaris";
    userEmail = "github@tripple.lurdane.de";
    extraConfig.credential.helper = "store";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      IdentityFile ${config.sops.secrets.ssh-private-key.path}
    '';
  };

}
