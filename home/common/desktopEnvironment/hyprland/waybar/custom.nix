{
  config,
  getColor,
  hostPrefs,
  lib,
  ...
}:
let
  inherit (lib) mkIf optionalString;
  prefs = config.userPrefs;
  displayManager = hostPrefs.displayManager or null;
  logoutCommand = if displayManager == "autologin" then null else "hyprctl dispatch exit";
  tooltipText =
    "Left: Lock | Right: Poweroff" + optionalString (logoutCommand != null) " | Middle: Logout";
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
      on-click = "hyprland";
      on-click-right = "poweroff -p";
      tooltip = true;
      tooltip-format = tooltipText;
      on-click-middle = mkIf (logoutCommand != null) logoutCommand;
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

    #custom-power {
      font-size: 20px;
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base08"};
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
