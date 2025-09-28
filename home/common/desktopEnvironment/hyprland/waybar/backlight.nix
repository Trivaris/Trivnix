{ getColor, ... }:
{
  settings.backlight = {
    format = " {}%";
    interval = 1;
    tooltip = false;

    on-scroll-down = "light -U 5";
    on-scroll-up = "light -A 5";
  };

  style = ''
    #backlight {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base09"};
      background: transparent;
    }
  '';
}
