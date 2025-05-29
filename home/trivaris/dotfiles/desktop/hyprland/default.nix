{
  config,
  lib,
  pkgs,
  ...
}: {

  imports = [
    ./hyprpaper.nix
    ./config.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}