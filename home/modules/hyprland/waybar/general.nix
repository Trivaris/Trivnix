{
  getColor,
  ...
}:
{
  settings = {
    layer = "top";
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
      background: transparent;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      margin-top: 6px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: transparent;
      background: transparent;
    }

    #workspaces {
      margin: 6px 12px 0;
      font-size: 4px;
      border-radius: 10px;
      background: ${getColor "base00"};
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
