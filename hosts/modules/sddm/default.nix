{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.sddm.enable = mkEnableOption "Enable SDDM Greeter";

  config = mkIf cfg.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
