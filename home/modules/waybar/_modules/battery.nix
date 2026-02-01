{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings.battery = {
    format = "{icon} {capacity}%";
    format-alt = "{time} {icon}";
    format-charging = " {capacity}%";
    format-plugged = " {capacity}%";
    format-icons = [
      " "
      " "
      " "
      " "
      " "
    ];

    states = {
      good = 95;
      warning = 30;
      critical = 20;
    };
  };

  style = ''
    #battery {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0C};
      background: transparent;
    }

    #battery.charging, #battery.plugged {
      color: ${theme.base0B};
      background-color: transparent;
    }

    #battery.critical:not(.charging) {
      background-color: transparent;
      color: ${theme.base08};
    }
  '';
}
