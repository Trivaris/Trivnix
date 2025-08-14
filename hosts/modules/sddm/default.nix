{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.hostprefs;
in
{
  options.hostprefs.sddm.enable = mkEnableOption "Enable SDDM Greeter";

  config = mkIf cfg.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
