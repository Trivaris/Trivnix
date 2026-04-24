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
      color: ${theme.base0C};
    }

    #battery.charging, #battery.plugged {
      color: ${theme.base0B};
    }

    #battery.critical:not(.charging) {
      color: ${theme.base08};
    }
  '';
}
