{ config, getColor, ... }:
let
  prefs = config.userPrefs;
in
{
  settings = {
    "custom/spotify" = {
      exec = ./scripts/spotify.sh;
      format = "{}";
      interval = 5;
      tooltip = false;
    };

    "custom/launcher" = {
      format = " ";

      on-click = "${prefs.appLauncher} ${config.vars.appLauncherFlags}";
      on-click-right = "killall ${prefs.appLauncher}";
    };
  };

  style = ''
    #custom-spotify {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base08"};
      background: transparent;
    }

    #custom-launcher {
      font-size: 24px;
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0C"};
      background: transparent;
    }

    #custom-wallpaper {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0D"};
      background: transparent;
    }
  '';
}
