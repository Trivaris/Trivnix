{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf (prefs.displayManager == "gdm") {
    services.displayManager.gdm.enable = true;
  };
}
