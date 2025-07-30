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
      eza.enable = true;
      fish.enable = true;
      fzf.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
      email.enable = true;

      vscodium = {
        enableLSP = true;
        fixServer = true;
      };

      desktopApps = [ "vscodium" ];

      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosConfig = {
    inherit (commons.nixosConfig) stylix;
  };
}