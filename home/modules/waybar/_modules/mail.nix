{
  config,
  osConfig,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  theme = osConfig.themingPrefs.scheme;
in
{
  settings."custom/mail" = {
    exec = ../scripts/mail.py;
    interval = 300;
    return-type = "json";
    signal = 4;
    tooltip = true;

    on-click = lib.mkIf prefs.thunderbird.enable "thunderbird";
    on-click-middle = "pkill -RTMIN+4 waybar";

    format = "{icon} {text}";
    format-icons = {
      empty = " ";
      error = " ";
      loading = " ";
      unread = " ";
    };
  };

  style = ''
    #custom-mail {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${theme.base0C};
      background: transparent;
    }

    #custom-mail.mail.unread {
      color: ${theme.base08};
    }

    #custom-mail.mail.error {
      color: ${theme.base09};
    }
  '';
}
