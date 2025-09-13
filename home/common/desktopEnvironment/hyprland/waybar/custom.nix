{
  config,
  getColor,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  settings = {
    "custom/spotify" = {
      exec = ./scripts/spotify.sh;
      interval = 5;
      format = "{}";
      tooltip = false;
    };

    "custom/launcher" = {
      format = " ";
      on-click = "${prefs.appLauncher} ${config.vars.appLauncherFlags}";
      on-click-right = "killall ${prefs.appLauncher}";
    };

    "custom/power" = {
      format = " ";
      on-click = "poweroff -p";
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
      on-click = "activate";
    };
  };

  style = ''
    #custom-spotify {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base08"};
    }

    #custom-launcher {
      font-size: 24px;
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0C"};
      background: ${getColor "base00"};
    }

    #custom-power {
      font-size: 20px;
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base08"};
    }

    #custom-wallpaper {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0D"};
    }
  '';
}
