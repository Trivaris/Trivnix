{
  getColor,
  ...
}:
{
  settings.bluetooth = {
    format = "{icon} {status}";
    format-connected = "{icon} {num_connections}";
    format-off = "{icon} off";
    format-on = "{icon} on";

    tooltip = true;
    tooltip-format = "{controller_alias} [{controller_address}]\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}";
    tooltip-format-enumerate-connected-battery = "{icon} {device_alias} ({device_battery_percentage}%)";

    format-icons = [
      ""
      ""
    ];

    on-click = "${./scripts/bluetooth-menu.sh}";
  };

  style = ''
    #bluetooth {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0D"};
      background: transparent;
    }
  '';
}
