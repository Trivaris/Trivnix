{ config, lib, ... }:
let
  nmAppletPrefs = config.hostPrefs.nmApplet;
in
{
  options.hostPrefs.nmApplet.enable = lib.mkEnableOption ''
    Enable the Network Manager applet in the system tray.
    Useful for managing network connections on laptops and desktops.
  '';

  config = lib.mkIf nmAppletPrefs.enable {
    programs.nm-applet.enable = true;
  };
}
