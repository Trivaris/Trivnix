{ osConfig, config, pkgs, lib, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    systemd.user.services.quickshell.Service.Environment = "QSG_RHI_BACKEND=vulkan QML_XHR_ALLOW_FILE_READ=1";
    home.packages = [ pkgs.quickshell ];
    
    programs.quickshell = {
      enable = true;
      systemd.enable = true;
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