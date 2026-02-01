{ osConfig, ... }:
let
  theme = osConfig.themingPrefs.scheme;
in
{
  settings = {
    clock = {
      interval = 60;

      format = " {:%H:%M}";
      format-alt = "󰃭 {:%A, %d %B %Y}";
    };

    tray = {
      icon-size = 18;
      spacing = 10;
    };

    cpu = {
      format = " {}%";
      interval = 15;
      max-length = 15;
    };

    memory = {
      format = " {}%";
      interval = 30;
      max-length = 10;
    };
  };

  style = ''
    #clock {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0B};
      background: transparent;
    }

    #tray {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0C};
      background: transparent;
    }

    #cpu {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0D};
      background: transparent;
    }

    #memory {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0E};
      background: transparent;
    }
  '';
}
