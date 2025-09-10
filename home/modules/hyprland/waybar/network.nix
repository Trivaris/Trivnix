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
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0E"};
    }
  '';
}
