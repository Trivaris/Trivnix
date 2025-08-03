let
  commons = import ./common.nix;
in
{
  name = "trivlaptop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.90";
  architecture = "x86_64-linux";

  users.trivaris = {    
    homeConfig = {
      inherit (commons.homeConfig) librewolf desktopApps extendedCli;

      email.enable = true;
      fish.enable = true;
      vscodium.enableLsp = true;
      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosConfig = {
    inherit (commons.nixosConfig) stylix;

    bluetooth.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
    gdm.enable = true;
    steam.enable = true;
  };
}