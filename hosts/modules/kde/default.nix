{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostprefs;
in
{
  options.hostprefs.kde.enable = mkEnableOption "Enable KDE Plasma";

  config = mkIf cfg.kde.enable {
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
      ++ (if (cfg.sddm.enable) then [ pkgs.kdePackages.sddm-kcm ] else [ ])
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
