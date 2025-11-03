{ getColor, ... }:
{
  settings.pulseaudio = {
    on-click = "pwvucontrol";
    on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    scroll-step = 5;
    tooltip = false;

    format = "{icon} {volume}%";
    format-muted = "  {volume}%";
    format-icons.default = [
      ""
      ""
      ""
    ];
  };

  style = ''
    #pulseaudio {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0A"};
      background: transparent;
    }
  '';
}
