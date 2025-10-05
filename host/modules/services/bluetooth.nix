{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.bluetooth.enable = mkEnableOption ''
    Enable Bluetooth hardware support and the Blueman applet.
    Activate when the host should pair controllers or audio devices.
  '';

  config = mkIf prefs.bluetooth.enable {
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
