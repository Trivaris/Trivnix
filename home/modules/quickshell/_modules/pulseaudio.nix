{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings.pulseaudio = {
    on-click = "pwvucontrol";
    on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    scroll-step = 5;
    tooltip = false;

    format = "{icon}   {volume}%";
    format-muted = "  {volume}%";
    format-icons.default = [
      ""
      ""
      ""
    ];
  };

  style = ''
    #pulseaudio {
      color: ${theme.base0A};
    }
  '';
}
