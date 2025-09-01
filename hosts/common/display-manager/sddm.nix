{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  config = mkIf (cfg.displayManager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
