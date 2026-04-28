{
  config,
  lib,
  pkgs,
  ...
}:
let
  bluetoothPrefs = config.hostPrefs.enable;
in
{
  options.hostPrefs.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth support";

  config = lib.mkIf bluetoothPrefs.enable {
    environment.systemPackages = [ pkgs.overskride ];
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Experimental = true;
        General.FastConnectable = true;
        Policy.AutoEnable = true;
      };
    };
  };
}
