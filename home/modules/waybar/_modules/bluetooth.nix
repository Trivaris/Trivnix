{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings.bluetooth = {
    on-click = "overskride";

    tooltip = true;
    tooltip-format = "{controller_alias} [{controller_address}]\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}";
    tooltip-format-enumerate-connected-battery = "{icon} {device_alias} ({device_battery_percentage}%)";

    format = "{icon} {status}";
    format-connected = "{icon} {num_connections}";
    format-off = "{icon} off";
    format-on = "{icon} on";
    format-icons = [
      " "
      " "
    ];
  };

  style = ''
    #bluetooth {
      color: ${theme.base0D};
    }
  '';
}
