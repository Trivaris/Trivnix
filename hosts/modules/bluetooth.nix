{ 
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.bluetooth = mkEnableOption "Bluetooth";

  config = mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };

}
