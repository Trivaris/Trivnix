{ config, lib, ... }:
let
  cfg = config.homeModules;
in
with lib;
{

  imports = [
    ./hyprpaper.nix
    ./settings.nix
  ];

  options.homeModules.hyprland = mkEnableOption "hyprland";
  config = mkIf cfg.hyprland {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };

}
