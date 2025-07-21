{
  name = "trivdesktop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.70";
  architecture = "x86_64-linux";

  users.trivaris = {    
    homeConfig = {
      librewolf.enable = true;
      wezterm.enable = true;
      eza.enable = true;
      fish.enable = true;
      fzf.enable = true;

      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosConfig = {
    bluetooth.enable = true;
    kde.enable = true;
    openssh.enable = true;
    printing.enable = true;
    tuigreet.enable = true;

    stylix = {
      enable = true;
      colorscheme = "everforest-dark-soft";

      cursorPackage = "rose-pine-cursor";
      cursorName = "BreezeX-RosePine-Linux";

      nerdfont = "CodeNewRoman";
    };
  };
}