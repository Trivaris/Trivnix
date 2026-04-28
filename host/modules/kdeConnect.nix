{
  lib,
  config,
  pkgs,
  ...
}:
let
  kdeConnectPrefs = config.hostPrefs.kdeConnect;
in
{
  options.hostPrefs.kdeConnect.enable = lib.mkEnableOption ''
    Install KDE Connect and open the required firewall ranges.
    Enable when pairing the host with mobile devices over the LAN.
  '';

  config = lib.mkIf kdeConnectPrefs.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
  };
}
