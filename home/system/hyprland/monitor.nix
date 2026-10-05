{ lib, osConfig, pkgs, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    home.packages = [ pkgs.waypaper pkgs.awww ];
    wayland.windowManager.hyprland.settings = {
      on = [ {
        _args = [ "hyprland.start" (lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("${lib.getExe pkgs.waypaper} --restore")
            hl.exec_cmd("librewolf",   { workspace =  "1 silent" })
            -- hl.exec_cmd("code",        { workspace =  "2 silent" })
            hl.exec_cmd("kitty",       { workspace =  "2 silent" })
            hl.exec_cmd("thunderbird", { workspace =  "3 silent" })
            hl.exec_cmd("feishin",     { workspace = "11 silent" })
            -- hl.exec_cmd("vesktop",     { workspace = "12 silent" })
          end
        '') ];
      } ];
      
      monitor = lib.mapAttrsToList (name: details: { _args = [ {
        output = name;
        mode = "${toString details.resolution}@${toString details.refreshRate}";
        position = "${toString details.position}";
        scale = toString details.scaling;
      } ]; } ) osConfig.hostInfos.monitors;

      workspace_rule = (lib.flatten (
        lib.mapAttrsToList ( name: m:
          map (i: {
            _args = [ { workspace = toString (i + (m.workspaceIndex * 10)); monitor = name; } ];
          }) (lib.range 1 5)
        ) osConfig.hostInfos.monitors
      )) ++ [ {
        _args = [ { workspace = 1; default = true; } ];
      }];
    };
  };
}
