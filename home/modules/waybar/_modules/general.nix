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
      font-size: 1.05rem;
      min-height: 0;
      font-weight: bold;
    }

    window#waybar {
      background: transparent;
      padding: 0;
      margin: 0;
    }

    .modules-left, .modules-center, .modules-right {
      background: ${theme.base00};
      border: 0.15rem solid ${theme.base03};
      border-radius: 0.5rem;
      padding: 0.4rem 0.8rem;
    }

    #backlight, #battery, #bluetooth, #custom-spotify, 
    #custom-launcher, #custom-mail, #clock, #tray, 
    #cpu, #memory, #network, #pulseaudio, #custom-weather {
      margin: 0 0.5em;
      padding: 0 0.6em;
      background: transparent;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #window {
      margin-top: 0;
      padding: 0px;
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
