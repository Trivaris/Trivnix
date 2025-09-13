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
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0C"};
    }

    #battery.charging, #battery.plugged {
      color: ${getColor "base00"};
      background-color: ${getColor "base0C"};
    }

    #battery.critical:not(.charging) {
      background-color: ${getColor "base0C"};
      color: ${getColor "base00"};
      animation: blink 0.5s linear infinite alternate;
    }
  '';
}
