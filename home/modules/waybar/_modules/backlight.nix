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
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base09};
      background: transparent;
    }
  '';
}
