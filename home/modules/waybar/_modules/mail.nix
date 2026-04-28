{
  config,
  osConfig,
  lib,
  ...
}:
let
  thunderbirdPrefs = config.userPrefs.thunderbird;
  theme = osConfig.themingPrefs.scheme;
in
{
  settings."custom/mail" = {
    exec = ../scripts/mail.py;
    interval = 300;
    return-type = "json";
    signal = 4;
    tooltip = true;

    on-click = lib.mkIf thunderbirdPrefs.enable "thunderbird";
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
      color: ${theme.base0C};
    }

    #custom-mail.mail.unread {
      color: ${theme.base08};
    }

    #custom-mail.mail.error {
      color: ${theme.base09};
    }
  '';
}
