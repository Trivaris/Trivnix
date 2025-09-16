{
  getColor,
  ...
}:
{
  settings.pulseaudio = {
    tooltip = false;
    scroll-step = 5;
    format = "{icon} {volume}%";
    format-muted = "  {volume}%";
    on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

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
