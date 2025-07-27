{ pkgs, config, lib, ... }:
with lib;
{
  options.nixosConfig.kde.enable = mkEnableOption "Enable KDE Plasma";

  config = mkIf config.nixosConfig.kde.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";

    environment.systemPackages = with pkgs; [
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kcolorchooser
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.sddm-kcm
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
