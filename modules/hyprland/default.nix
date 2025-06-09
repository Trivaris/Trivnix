{ config, lib, ... }:
let
  cfg = config.modules;
in
with lib;
{

  imports = [
    ./hyprpaper.nix
  ];

  options.modules.hyprland = mkEnableOption "hyprland";
  config = mkIf cfg.hyprland {

    wayland.windowManager.hyprland = {
      enable = true;
    };
  };

}
