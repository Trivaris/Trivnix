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
      email.enable = true;
      lutris.enable = true;

      vscodium = {
        enableLSP = true;
      };

      fish.enable = true;
      eza.enable = true;
      fzf.enable = true;

      git.email = "github@tripple.lurdane.de";

      inherit (commons.homeConfig) librewolf desktopApps;
    };
  };

  nixosConfig = {
    bluetooth.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
    gdm.enable = true;
    steam.enable = true;

    inherit (commons.nixosConfig) stylix;
  };
}