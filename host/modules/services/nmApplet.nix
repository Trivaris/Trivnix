{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.nmApplet.enable = lib.mkEnableOption ''
    Enable the Network Manager applet in the system tray.
    Useful for managing network connections on laptops and desktops.
  '';

  config = mkIf prefs.nmApplet.enable {
    programs.nm-applet.enable = true;
  };
}
