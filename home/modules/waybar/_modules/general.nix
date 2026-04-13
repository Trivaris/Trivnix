{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
  themePrefs = osConfig.themingPrefs;
in
{
  settings = {
    layer = "top";
    height = 42;

    margin-bottom = 0;
    margin-left = 10;
    margin-right = 10;
    margin-top = 10;

    modules-left = [
      "custom/launcher"
      "cpu"
      "memory"
      "network"
      "bluetooth"
      "tray"
    ];

    modules-center = [
      "hyprland/workspaces"
    ];

    modules-right = [
      "custom/spotify"
      "custom/mail"
      "custom/weather"
      "backlight"
      "pulseaudio"
      "battery"
      "clock"
    ];
  };

  style = ''
    * {
      font-family: "${themePrefs.font.name} Font";
      font-size: 17px;
      min-height: 10px;
      font-weight: bold;
    }

    window#waybar {
      background: transparent;
    }

    .modules-left, .modules-center, .modules-right {
      border: solid 2px ${theme.base02};
      border-radius: 8px;
      background: ${theme.base00};
      border-radius: 4px;
      border: solid 2px transparent;
      padding: 5px 15px;
      transition: border-color 0.2s ease;
    }

    #waybar .modules-center:hover {
      border: 2px solid ${theme.base02};
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      margin-top: 0;
      padding: 0 10px;
      border-radius: 8px;
      transition: none;
      color: transparent;
      background: transparent;
    }

    @keyframes blink {
      to {
        background-color: ${theme.base08};
        color: ${theme.base0C};
      }
    }
  '';
}
