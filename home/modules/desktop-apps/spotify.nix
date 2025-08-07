{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.homeConfig;
in
{
  config = mkIf (builtins.elem "spotify" cfg.desktopApps) {
    programs.spicetify = {
      enable = true;
    };
  };
}
