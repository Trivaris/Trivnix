{
  config,
  getColor,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  thunderbirdEnabled = builtins.elem "thunderbird" guiModules;
  guiModules = prefs.gui or [ ];
in
{
  settings."custom/mail" = {
    exec = "${./scripts/mail.py}";
    interval = 300;
    return-type = "json";
    signal = 4;
    tooltip = true;

    on-click = mkIf thunderbirdEnabled "thunderbird";
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
