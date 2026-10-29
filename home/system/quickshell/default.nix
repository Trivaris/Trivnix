{ osConfig, config, pkgs, lib, ... }:
let 
  scheme = osConfig.themingPrefs.scheme;
in 
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    systemd.user.services.quickshell.Service.Environment = "QSG_RHI_BACKEND=vulkan QML_XHR_ALLOW_FILE_READ=1";
    home.packages = [ pkgs.quickshell ];
    
    programs.quickshell = {
      enable = true;
      systemd.enable = true;
    };

    gtk = {
      enable = true;
      gtk3.extraCss = ''
        /* Style system tray and context menus */
        menu, .menu {
          background-color: ${scheme.base00};
          border: 1px solid ${scheme.base02};
          border-radius: 8px;
          padding: 4px;
        }

        menu menuitem, .menu menuitem {
          color: ${scheme.base05};
          padding: 6px 10px;
          border-radius: 4px;
        }

        menu menuitem:hover, .menu menuitem:hover {
          background-color: ${scheme.base02};
          color: ${scheme.base07 or scheme.base05};
        }

        menu separator, .menu separator {
          background-color: ${scheme.base02};
          min-height: 1px;
          margin: 4px 0;
        }
      '';
      gtk4.extraCss = ''
        popover.menu {
          background-color: ${scheme.base00};
          border: 1px solid ${scheme.base02};
          border-radius: 8px;
          color: ${scheme.base05};
        }
      '';
    };

    wayland.windowManager.hyprland.settings = {
      window_rule = [
        { _args = [ {
          name = "Add rounding and shadow to quickshell popups/menus";
          match.class = "^(quickshell)$";
          rounding = 8;
          no_shadow = true;
        } ]; }
      ];

      layer_rule = [
        { _args = [ {
          name = "Blur layer-shell surfaces behind the menus";
          match.namespace = "quickshell";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.1;
        } ]; }
      ];
    };

    xdg.configFile = {
      "quickshell/wsIconOverrides.json".text = builtins.toJSON config.userPrefs.quickshell.wsIconOverrides;
      "quickshell/scheme.json".text = builtins.toJSON osConfig.themingPrefs.scheme;
      "quickshell/monitors.json".text = builtins.toJSON osConfig.hostInfos.monitors;
      "quickshell/weather.sh" = {
        executable = true;
        text = import ./_scripts/weather.nix pkgs;
      };
      "quickshell" = {
        recursive = true;
        source = ./_modules;
      };
    };
  };
}