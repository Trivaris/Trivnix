{
  mainBar = {
    layer = "top";
    position = "top";
    height = 28;

    modules-left = [
      "hyprland/workspaces"
    ];

    modules-center = [
      "clock"
    ];

    modules-right = [
      "pulseaudio"
      "network"
      "battery"
      "tray"
    ];

    "hyprland/workspaces" = {
      all-outputs = true;
      disable-scroll = true;
    };

    clock = {
      # Example: Mon 09 Sep  20:42
      format = "{:%a %d %b  %H:%M}";
      tooltip = false;
    };

    pulseaudio = {
      format = "{volume}% {icon}";
      format-muted = "muted ";
      on-click = "pavucontrol";
      format-icons = {
        headphones = "";
        default = [
          ""
          ""
        ];
      };
    };

    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ifname} ";
      format-linked = "{ifname} ";
      format-disconnected = "disconnected ";
      tooltip = false;
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };
  };
}
