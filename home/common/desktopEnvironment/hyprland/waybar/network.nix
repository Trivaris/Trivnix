{
  getColor,
  ...
}:
{
  settings.network = {
    format-wifi = " ";
    format-ethernet = "󰌗 ";
    tooltip-format = "{essid} ({signalStrength}%)";
    format-linked = "{ifname} (No IP) 󰌗";
    format-disconnected = "⚠ ";
    format-alt = "{ifname}: {ipaddr}/{cidr}";
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
