{
  getColor,
  ...
}:
{
  settings = {
    clock = {
      format = " {:%H:%M}";
      tooltip-format = "{:%A, %d %B %Y}";
      interval = 60;
    };

    tray = {
      icon-size = 18;
      spacing = 10;
    };

    cpu = {
      interval = 15;
      format = " {}%";
      max-length = 15;
    };

    memory = {
      interval = 30;
      format = " {}%";
      max-length = 10;
    };
  };

  style = ''
    #clock {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0B"};
      background: transparent;
    }

    #tray {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0C"};
      background: transparent;
    }

    #cpu {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0D"};
      background: transparent;
    }

    #memory {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0E"};
      background: transparent;
    }
  '';
}
