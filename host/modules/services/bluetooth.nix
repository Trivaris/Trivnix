{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.bluetooth.enable = lib.mkEnableOption ''
    Enable Bluetooth hardware support and the Blueman applet.
    Activate when the host should pair controllers or audio devices.
  '';

  config = lib.mkIf prefs.bluetooth.enable {
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
