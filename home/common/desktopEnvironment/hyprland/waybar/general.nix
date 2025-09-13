{
  getColor,
  ...
}:
{
  settings = {
    layer = "top";
    margin-top = 0;
    margin-left = 0;
    margin-right = 0;
    margin-bottom = 12;
    height = 42;
    modules-center = [ "hyprland/workspaces" ];

    modules-left = [
      "custom/launcher"
      "cpu"
      "memory"
      "network"
      "bluetooth"
      "tray"
    ];

    modules-right = [
      "custom/spotify"
      "backlight"
      "pulseaudio"
      "battery"
      "clock"
      "custom/power"
    ];
  };

  style = ''
    * {
      border: none;
      border-radius: 10px;
      font-family: "JetbrainsMono Nerd Font" ;
      font-size: 17px;
      min-height: 10px;
    }

    window#waybar {
      background: ${getColor "base00"};
      margin: 0;
      padding: 8px 12px; /* add vertical room so background is taller */
      border-radius: 0 0 20px 20px; /* round bottom only to frame wallpaper */
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      /* reset inherited margins to let window padding control vertical spacing */
      margin-top: 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: transparent;
      background: transparent;
    }

    #workspaces {
      margin: 0 12px;
      font-size: 4px;
      border-radius: 10px;
      background: transparent;
      transition: none;
    }

    #workspaces button {
      transition: none;
      color: ${getColor "base0C"};
      background: transparent;
      font-size: 16px;
      border-radius: 2px;
    }

    #workspaces button.occupied {
      transition: none;
      color: ${getColor "base08"};
      background: transparent;
      font-size: 4px;
    }

    #workspaces button:hover {
      transition: none;
      box-shadow: inherit;
      text-shadow: inherit;
      color: ${getColor "base0A"};
      border-color: ${getColor "base08"};
    }

    #workspaces button.active:hover {
      color: ${getColor "base08"};
    }

    @keyframes blink {
      to {
        background-color: ${getColor "base08"};
        color: ${getColor "base0C"};
      }
    }
  '';
}
