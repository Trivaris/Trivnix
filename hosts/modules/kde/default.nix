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
    # stylix.targets.qt.platform = mkForce "qtct";

    environment.systemPackages = with pkgs; [
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kcolorchooser
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      (mkIf cfg.sddm.enable kdePackages.sddm-kcm)
      kdePackages.systemsettings
      kdePackages.kdeconnect-kde
      kdiff3
      kdePackages.isoimagewriter
      kdePackages.partitionmanager
      hardinfo2
      wayland-utils
      wl-clipboard
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
