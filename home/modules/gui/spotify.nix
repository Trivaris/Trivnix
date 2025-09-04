{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "spotify" prefs.gui) {
    programs.spicetify = {
      enable = true;
    };
  };
}
