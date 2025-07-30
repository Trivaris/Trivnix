{ pkgs, config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "bitwarden" cfg.desktopApps) {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
