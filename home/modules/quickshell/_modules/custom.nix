{ pkgs, lib, osConfig, ... }:
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

      on-click = "${lib.getExe pkgs.rofi} -show drun";
      on-click-right = "killall ${pkgs.rofi}";
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      on-scroll-up = ''hyprctl dispatch "hl.dsp.focus({ workspace = 'e+1' })"'';
      on-scroll-down = ''hyprctl dispatch "hl.dsp.focus({ workspace = 'e-1' })"'';
      on-click = "activate";
    };
  };

  style = ''
    #custom-spotify {
      color: ${theme.base08};
    }

    #custom-launcher {
      font-size: 1.5rem;
      color: ${theme.base0C};
    }

    #custom-wallpaper {
      color: ${theme.base0D};
    }
  '';
}
