{
  getColor,
  ...
}:
{
  settings.battery = {
    format = "{icon}  {capacity}%";
    format-charging = " {capacity}%";
    format-plugged = " {capacity}%";
    format-alt = "{time} {icon}";

    format-icons = [
      ""
      ""
      ""
      ""
      ""
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
      color: ${getColor "base0C"};
      background: transparent;
    }

    #battery.charging, #battery.plugged {
      color: ${getColor "base0B"};
      background-color: transparent;
    }

    #battery.critical:not(.charging) {
      background-color: transparent;
      color: ${getColor "base08"};
    }
  '';
}
