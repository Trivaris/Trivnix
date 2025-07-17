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

  options.homeModules.hyprland.enable = mkEnableOption "hyprland";
  
  config = mkIf cfg.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };

}
