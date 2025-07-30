{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "spotify" cfg.desktopApps) {
    programs.spicetify = {
      enable = true;
    };
  };
}