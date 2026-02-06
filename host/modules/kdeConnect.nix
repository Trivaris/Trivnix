{ lib, config, ... }:
let 
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.kdeConnect.enable = lib.mkEnableOption ''
    Install KDE Connect and open the required firewall ranges.
    Enable when pairing the host with mobile devices over the LAN.
  '';
  
  config = lib.mkIf prefs.kdeConnect.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}