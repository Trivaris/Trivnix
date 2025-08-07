{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";

  config = mkIf (cfg.bluetooth.enable) {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
