{
  getColor,
  ...
}:
{
  settings.backlight = {
    tooltip = false;
    format = " {}%";
    interval = 1;
    on-scroll-up = "light -A 5";
    on-scroll-down = "light -U 5";
  };

  style = ''
    #backlight {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base09"};
    }
  '';
}
