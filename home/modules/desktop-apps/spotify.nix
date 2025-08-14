{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "spotify" cfg.desktopApps) {
    programs.spicetify = {
      enable = true;
    };
  };
}
