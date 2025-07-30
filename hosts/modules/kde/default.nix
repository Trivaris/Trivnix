{ pkgs, config, lib, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.kde.enable = mkEnableOption "Enable KDE Plasma";

  config = mkIf cfg.kde.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";
    services.displayManager.sddm.wayland.compositor = "kwin";

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      elisa
    ];

    environment.systemPackages = with pkgs; [
      (mkIf cfg.sddm.enable kdePackages.sddm-kcm)

      kdePackages.kcalc
      kdePackages.ksystemlog
      kdePackages.systemsettings
      kdePackages.kdeconnect-kde
      kdePackages.plasma-browser-integration
      kdePackages.ktorrent
      hardinfo2
      wayland-utils
      wl-clipboard
      vlc
    ];

    # KDE Connect
    networking.firewall = { 
      enable = true;
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; }
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; }
      ];  
    }; 
  };

}
