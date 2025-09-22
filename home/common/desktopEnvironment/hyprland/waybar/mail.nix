{
  config,
  getColor,
  lib,
  ...
}:
let
  inherit (lib) optionalAttrs;
  prefs = config.userPrefs;
  guiModules = prefs.gui or [ ];
  thunderbirdEnabled = builtins.elem "thunderbird" guiModules;
in
{
  settings."custom/mail" = {
    format = "{icon} {text}";
    return-type = "json";
    interval = 300;
    tooltip = true;
    exec = "${./scripts/mail.py}";
    signal = 4;
    on-click-middle = "pkill -RTMIN+4 waybar";

    format-icons = {
      loading = "";
      unread = "";
      empty = "";
      error = "";
    };
  }
  // optionalAttrs thunderbirdEnabled {
    on-click = "thunderbird";
  };

  style = ''
    #custom-mail {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base0C"};
      background: transparent;
    }

    #custom-mail.mail.unread {
      color: ${getColor "base08"};
    }

    #custom-mail.mail.error {
      color: ${getColor "base09"};
    }
  '';
}
