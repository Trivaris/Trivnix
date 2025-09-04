{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.desktopEnvironment == "kde") {
    qt.platformTheme = lib.mkForce "kde";

    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";
    services.displayManager.sddm.wayland.compositor = "kwin";

    environment.plasma6.excludePackages = builtins.attrValues {
      inherit (pkgs.kdePackages)
        konsole
        elisa
        ;
    };

    environment.systemPackages = (
      builtins.attrValues {
        inherit (pkgs)
          hardinfo2
          wayland-utils
          wl-clipboard
          vlc
          ;

        inherit (pkgs.kdePackages)
          kcalc
          ksystemlog
          systemsettings
          kdeconnect-kde
          plasma-browser-integration
          ktorrent
          ;
      }
      ++ (if (prefs.displayManager == "sddm") then [ pkgs.kdePackages.sddm-kcm ] else [ ])
    );

    # KDE Connect
    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

}
