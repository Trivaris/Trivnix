{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";
  
  config = mkIf (cfg.bluetooth.enable) {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
