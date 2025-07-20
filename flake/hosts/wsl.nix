{
  name = "trivwsl";
  stateVersion = "24.11";
  hardwareKey = false;
  ip = "192.168.178.70";
  architecture = "x86_64-linux";
  
  users.trivaris = {
    name = "trivaris";
    homeModules = {
      cli-utils.enable = true;
      fish.enable = true;
      git.email = "github@tripple.lurdane.de";
    };
  };
  
  nixosModules = {
    fish.enable = true;
    openssh = {
      enable = true;
    };
  };
}