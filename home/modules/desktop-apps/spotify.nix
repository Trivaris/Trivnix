{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "spotify" prefs.desktopApps) {
    programs.spicetify = {
      enable = true;
    };
  };
}
