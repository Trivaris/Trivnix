{ config, lib, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.sddm.enable = mkEnableOption "Enable SDDM Greeter";

  config = mkIf cfg.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
