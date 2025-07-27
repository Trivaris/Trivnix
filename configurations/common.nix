{
  homeConfig = {
    terminals = [ "wezterm" ];

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

  nixosConfig = {
    stylix = {
      enable = true;
      colorscheme = "tokyo-night-dark";

      cursorPackage = "rose-pine-cursor";
      cursorName = "BreezeX-RosePine-Linux";

      nerdfont = "code-new-roman";
    };
  };
}