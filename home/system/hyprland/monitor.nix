{ lib, osConfig, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList (
      name: details:
      "${name},${details.resolution}@${details.refreshRate},${details.position},${details.scaling}"
    ) osConfig.hostInfos.monitors;

    services.hyprpaper = {
      enable = true;
      settings = {
        wallpaper = lib.mapAttrsToList (name: details: {
          monitor = name;
          path = details.wallpaper;
        }) osConfig.hostInfos.monitors;
      };
    };
  };
}
