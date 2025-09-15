{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.bluetooth.enable = mkEnableOption "Enable Bluetooth";

  config = mkIf prefs.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
