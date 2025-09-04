{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "vesktop" prefs.desktopApps) {
    programs.vesktop = {
      enable = true;
    };
  };
}
