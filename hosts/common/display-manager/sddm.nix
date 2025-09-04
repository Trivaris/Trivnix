{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.displayManager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
