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
      border: none;
      border-radius: 10px;
      font-family: "${themePrefs.font.name} Font" ;
      font-size: 17px;
      min-height: 10px;
      font-weight: bold;
    }

    window#waybar {
      background: transparent;
    }

    .modules-left, .modules-center, .modules-right {
      background: ${theme.base00};
      border-radius: 24px;
      padding: 5px 15px;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      margin-top: 0;
      padding: 0 10px;
      border-radius: 10px;
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
