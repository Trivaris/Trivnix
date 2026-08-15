{ lib, osConfig, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.mapAttrsToList (name: details: { _args = [ {
        output = name;
        mode = "${toString details.resolution}@${toString details.refreshRate}";
        position = "${toString details.position}";
        scale = toString details.scaling;
      } ]; } ) osConfig.hostInfos.monitors;

      workspace_rule = lib.flatten (
        lib.mapAttrsToList ( name: m:
          map (i: {
            _args = [ { workspace = toString (i + (m.workspaceIndex * 10)); monitor = name; } ];
          }) (lib.range 1 10)
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
