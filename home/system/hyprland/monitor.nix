{ lib, osConfig, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.mapAttrsToList (
        name: details:
        "${name},${details.resolution}@${details.refreshRate},${details.position},${details.scaling}"
      ) osConfig.hostInfos.monitors;

      workspace = lib.flatten (
        lib.mapAttrsToList (
          name: m: map (i: "${toString (i + (m.workspaceIndex * 10))}, monitor:${name}") (lib.range 1 10)
        ) osConfig.hostInfos.monitors
      );
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        wallpaper = lib.mapAttrsToList (name: details: {
          monitor = name;
          path = toString details.wallpaper;
        }) osConfig.hostInfos.monitors;
      };
    };
  };
}
