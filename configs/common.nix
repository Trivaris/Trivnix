{
  user = {
    librewolf = {
      betterfox = true;
      clearOnShutdown = true;
      allowedCookies = [
        "https://github.com"
        "https://asuracomic.net"
        "https://www.kenmei.co"
        "https://www.youtube.com"
        "https://www.livechart.me"
        "https://anilist.co"
        "https://www.cloudflare.com"
        "https://auth.mangadex.org"
        "https://www.reddit.com"
        "https://www.google.com"
        "https://vault.trivaris.org"
        "https://accounts.google.com"
        "https://mangadex.org"
        "https://chatgpt.com/"
        "https://www.notion.so"
        "https://web.whatsapp.com/"
        "https://f95zone.to/"
        "https://www.instagram.com/"
      ];
    };

    desktopApps = [
      "librewolf"
      "vscodium"
      "alacritty"
      "bitwarden"
      "signal"
      "spotify"
      "thunderbird"
      "vesktop"
      "moonlight-qt"
    ];

    extendedCli = [
      "bat"
      "btop"
      "eza"
      "fzf"
      "nvim"
      "zoxide"
    ];
  };

  host = {
    stylix = {
      colorscheme = "rose-pine-moon";

      cursorPackage = "rose-pine-cursor";
      cursorName = "BreezeX-RosePine-Linux";

      nerdfont = "code-new-roman";
    };
  };
}
