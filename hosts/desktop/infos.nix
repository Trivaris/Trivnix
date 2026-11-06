{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/qr/wallhaven-qroy2d.png";
        hash = "sha256-EG2VpqzkAPrA/MFkB79s6MFqQ0L9/PVYlCfw39RqRO0=";
      };
      # wallpaper = pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/Trivaris/TrivnixConfigs/e7383738eaf25f7350ebdcd97bac6e3e5bb234f3/resources/wallpapers/miles-morales-leap.jpg";
      #   hash = "sha256-+kbzasa2cuxVZ90lpgQ3SCaAuv2+0ufovKBAlEBp9Vw=";
      # };
    in
    {
      hostInfos = {
        name = "leyndell";
        configname = "desktop";
        stateVersion = "26.05";
        ip = "192.168.178.2";
        architecture = "x86_64-linux";
        hashedRootPassword = "$y$j9T$R.NIp2RpQQOwy48wQU19n1$wHb/Nub4Bt1yCtrMEWe3iLSBx1WvfnncRq95AqFBKh3";
        primaryMonitor = "DP-2";
        monitors = {
          "HDMI-A-1" = {
            resolution = "1920x1080";
            refreshRate = "60";
            position = "0x840";
            scaling = "1";
            workspaceIndex = 1;
            wallpaper = wallpaper;
          };

          "DP-1" = {
            resolution = "2560x1440";
            refreshRate = "74.97";
            position = "1920x480";
            scaling = "1";
            workspaceIndex = 0;
            wallpaper = wallpaper;
          };
        };
      };
    };
}
