{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.plugins = [
    pkgs.split-monitor-workspaces
  ];
}