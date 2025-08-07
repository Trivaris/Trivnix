let
  commons = import ./common.nix;
in
{
  name = "trivwsl";
  stateVersion = "24.11";
  hardwareKey = false;
  ip = "192.168.178.70";
  architecture = "x86_64-linux";
  colorscheme = "everforest-dark-soft";

  users.trivaris = {
    homeConfig = {
      inherit (commons.homeConfig) extendedCli;

      fish.enable = true;
      email.enable = true;
      desktopApps = [ "vscodium" ];
      git.email = "github@tripple.lurdane.de";

      vscodium = {
        enableLsp = true;
        fixServer = true;
      };
    };
  };

  nixosConfig = {
    inherit (commons.nixosConfig) stylix;
  };
}
