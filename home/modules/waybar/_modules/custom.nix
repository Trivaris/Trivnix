{ osConfig, config, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings = {
    "custom/spotify" = {
      exec = ../scripts/spotify.sh;
      format = "{}";
      interval = 5;
      tooltip = false;
    };

    "custom/launcher" = {
      format = " ";

      on-click = "${config.vars.appLauncher} ${config.vars.appLauncherFlags}";
      on-click-right = "killall ${config.vars.appLauncher}";
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
      on-click = "activate";
    };
  };

  style = ''
    #workspaces button {
      padding: 0 10px;
      background: transparent;
      color: ${theme.base05};
      transition: all 0.3s ease;
    }

    #workspaces button.active {
      color: ${theme.base0D};
      background: transparent;
      border-bottom: 3px solid ${theme.base0D};
      border-radius: 0;
    }

    #custom-spotify {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base08};
      background: transparent;
    }

    #custom-launcher {
      font-size: 24px;
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0C};
      background: transparent;
    }

    #custom-wallpaper {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0D};
      background: transparent;
    }
  '';
}
