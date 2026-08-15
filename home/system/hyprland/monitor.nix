{ lib, osConfig, pkgs, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland = {
      extraConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: details: ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("${lib.getExe pkgs.mpvpaper} -o 'no-audio loop' ${name} ${details.wallpaper}")
        end)
      '') osConfig.hostInfos.monitors);
      
      settings = {
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
    };
  };
}
