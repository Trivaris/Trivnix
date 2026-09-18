{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings.network = {
    on-click = "nmgui";
    on-click-right = "nm-connection-editor";
    format-alt-click = "click-middle";

    tooltip-format = "{essid} ({signalStrength}%)";

    format-alt = "{ifname}: {ipaddr}/{cidr}";
    format-disconnected = " ";
    format-ethernet = "󰌗 ";
    format-linked = "{ifname} (No IP) 󰌗 ";
    format-wifi = " ";
  };

  style = ''
    #network {
      color: ${theme.base0E};
    }
  '';
}
