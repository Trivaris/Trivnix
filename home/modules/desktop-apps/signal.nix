{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "signal" cfg.desktopApps) {
    home.packages = with pkgs; [
      signal-desktop
    ];
  };
}
