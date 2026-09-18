{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings = {
    clock = {
      interval = 60;

      format = "   {:%H:%M}";
      format-alt = "󰃭 {:%A, %d %B %Y}";
    };

    tray = {
      icon-size = 18;
      spacing = 10;
    };

    cpu = {
      format = "   {}%";
      interval = 15;
      max-length = 15;
    };

    memory = {
      format = "   {}%";
      interval = 30;
      max-length = 10;
    };
  };

  style = ''
    #clock {
      color: ${theme.base0B};
    }

    #tray {
      color: ${theme.base0C};
    }

    #cpu {
      color: ${theme.base0D};
    }

    #memory {
      color: ${theme.base0E};
    }
  '';
}
