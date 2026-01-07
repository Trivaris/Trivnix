{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.nmApplet.enable = lib.mkEnableOption ''
    Enable the Network Manager applet in the system tray.
    Useful for managing network connections on laptops and desktops.
  '';

  config = lib.mkIf prefs.nmApplet.enable {
    programs.nm-applet.enable = true;
  };
}
