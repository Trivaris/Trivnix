{ hostInfos, lib, ... }:
{
  config = lib.mkIf (hostInfos ? monitors) {
    wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList (
      name: details:
      "${name},${details.resolution}@${details.refreshRate},${details.position},${details.scaling}"
    ) hostInfos.monitors;

    services.hyprpaper = {
      enable = true;
      settings = {
        wallpaper = lib.mapAttrsToList (name: details: {
          monitor = name;
          path = details.wallpaper;
        }) hostInfos.monitors;
      };
    };

    stylix.targets.hyprpaper.enable = false;
    stylix.targets.hyprpaper.image.enable = false;
  };
}
