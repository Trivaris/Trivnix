{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {

  imports = [
    ./config.nix
  ];

  options.features.desktop.hyprland.enable = mkEnableOption "extended hyprland configuration";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

}