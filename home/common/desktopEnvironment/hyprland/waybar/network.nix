{ getColor, ... }:
{
  settings.network = {
    tooltip-format = "{essid} ({signalStrength}%)";

    format-alt = "{ifname}: {ipaddr}/{cidr}";
    format-disconnected = " ";
    format-ethernet = "󰌗 ";
    format-linked = "{ifname} (No IP) 󰌗 ";
    format-wifi = " ";
  };

  style = ''
    #network {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0E"};
      background: transparent;
    }
  '';
}
