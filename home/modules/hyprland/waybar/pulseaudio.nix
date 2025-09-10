{
  getColor,
  ...
}:
{
  settings.pulseaudio = {
    tooltip = false;
    scroll-step = 5;
    format = "{icon} {volume}%";
    format-muted = "{icon} {volume}%";
    on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

    format-icons.default = [
      ""
      ""
      ""
    ];
  };

  style = ''
    #pulseaudio {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0A"};
    }
  '';
}
