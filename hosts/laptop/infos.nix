{
  flake.nixosModules.laptop =
    { pkgs, ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Trivaris/TrivnixConfigs/e7383738eaf25f7350ebdcd97bac6e3e5bb234f3/resources/wallpapers/miles-morales-leap.jpg";
        hash = "sha256-+kbzasa2cuxVZ90lpgQ3SCaAuv2+0ufovKBAlEBp9Vw=";
      };
    in
    {
      hostInfos = {
        name = "liurnia";
        configname = "laptop";
        stateVersion = "26.05";
        ip = "192.168.178.3";
        architecture = "x86_64-linux";
        hashedRootPassword = "$y$j9T$8F3.B8RZQR714UuB45yEH.$9hYpLjzuz5I85nIZ/8d2n58i8Q3qXhiESOWV.3wSPD0";
        primaryMonitor = "eDP-1";
        monitors = {
          "eDP-1" = {
            resolution = "1920x1080";
            refreshRate = "60";
            position = "0x0";
            scaling = "1";
            workspaceIndex = 0;
            wallpaper = wallpaper;
          };
          "DP-3" = {
            resolution = "1920x1080";
            refreshRate = "60";
            position = "1920x0";
            scaling = "1";
            workspaceIndex = 1;
            wallpaper = wallpaper;
          };
          "DP-4" = {
            resolution = "1920x1200";
            refreshRate = "59.95";
            position = "3840x0";
            scaling = "1";
            workspaceIndex = 2;
            wallpaper = wallpaper;
          };
        };
      };
    };
}
