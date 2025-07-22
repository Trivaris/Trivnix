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

      vscodium = {
        enable = true;
        enableLSP = true;
        fixServer = true;
      };

      git.email = "github@tripple.lurdane.de";
    };
  };

  nixosConfig = {
    openssh.enable = true;

    stylix = {
      enable = true;
      colorscheme = "everforest-dark-soft";

      cursorPackage = "rose-pine-cursor";
      cursorName = "BreezeX-RosePine-Linux";

      nerdfont = "CodeNewRoman";
    };
  };
}