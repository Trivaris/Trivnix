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
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0B"};
    }

    #tray {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0C"};
      background: ${getColor "base00"};
    }

    #cpu {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0D"};
    }

    #memory {
      margin: 6px 8px 0;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base00"};
      background: ${getColor "base0E"};
    }
  '';
}
