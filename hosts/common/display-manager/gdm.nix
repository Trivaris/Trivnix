{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.displayManager == "gdm") {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
