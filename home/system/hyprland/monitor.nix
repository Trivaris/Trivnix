{ lib, osConfig, pkgs, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    home.packages = [ pkgs.waypaper pkgs.awww ];
    wayland.windowManager.hyprland.settings = {
      on = [ {
        _args = [ "hyprland.start" (lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("${lib.getExe pkgs.waypaper} --restore")
            hl.exec_cmd("librewolf")
            hl.exec_cmd("code")
            hl.exec_cmd("kitty")
            hl.exec_cmd("feishin")
            hl.exec_cmd("vesktop")
          end
        '') ];
      } ];
      
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
          }) (lib.range 1 5)
        ) osConfig.hostInfos.monitors
      );
    };
  };
}
