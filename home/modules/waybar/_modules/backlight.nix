{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings.backlight = {
    format = " {}%";
    interval = 1;
    tooltip = false;

    on-scroll-down = "brightnessctl s +5%";
    on-scroll-up = "brightnessctl s 5%-";
  };

  style = ''
    #backlight {
      color: ${theme.base09};
    }
  '';
}
