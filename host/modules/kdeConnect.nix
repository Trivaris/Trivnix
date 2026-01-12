{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.kdeConnect.enable = lib.mkEnableOption ''
    Install KDE Connect and open the required firewall ranges.
    Enable when pairing the host with mobile devices over the LAN.
  '';

  config = lib.mkIf prefs.kdeConnect.enable {
    environment.systemPackages = [ pkgs.kdePackages.kdeconnect-kde ];
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
