{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.kdeConnect.enable = mkEnableOption "Enable KDE Connect";

  config = mkIf (prefs.kdeConnect.enable == true) {
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
