{ lib, config, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList (
    name: details:
    "${name},${details.resolution}@${details.refreshRate},${details.position},${details.scaling}"
  ) config.hostInfos.monitors;

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = lib.mapAttrsToList (name: details: {
        monitor = name;
        path = details.wallpaper;
      }) config.hostInfos.monitors;
    };
  };
}
