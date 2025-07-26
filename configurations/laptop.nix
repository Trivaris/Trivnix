{
  name = "trivlaptop";
  stateVersion = "25.05";
  hardwareKey = true;
  ip = "192.168.178.90";
  architecture = "x86_64-linux";
  colorscheme = "everforest-dark-soft";

  users.trivaris = {
    homeConfig = {
      wezterm.enable = true;
      eza.enable = true;
      fish.enable = true;
      fzf.enable = true;
      spotify.enable = true;
      thunderbird.enable = true;
      email.enable = true;

      git.email = "github@tripple.lurdane.de";

      librewolf = {
        enable = true;
        betterwolf = true;
        clearOnShutdown = true;
        allowedCookies = [
          "https://github.com"
          "https://asuracomic.net"
          "https://www.kenmei.co"
          "https://www.youtube.com"
          "https://www.figma.com"
          "https://f95zone.to"
          "https://www.livechart.me"
          "https://anilist.co"
          "https://www.cloudflare.com"
          "https://auth.mangadex.org"
          "https://www.reddit.com"
          "https://www.google.com"
          "https://vault.trivaris.org"
          "https://accounts.google.com"
          "https://mangadex.org"
        ];
      };
    };
  };

  nixosConfig = {
    bluetooth.enable = true;
    openssh.enable = true;
    printing.enable = true;
    kde.enable = true;
    sddm.enable = true;

    stylix = {
      enable = true;
      colorscheme = "tokyo-night-dark";

      cursorPackage = "rose-pine-cursor";
      cursorName = "BreezeX-RosePine-Linux";

      nerdfont = "code-new-roman";
    };
  };
}