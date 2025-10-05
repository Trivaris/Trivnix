{
  config,
  getColor,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  inherit (lib) escapeShellArg optionalString;
  location = prefs.hyprland.weatherLocation;
  locationArg = optionalString (location != null && location != "") " ${escapeShellArg location}";
in
{
  settings."custom/weather" = {
    exec = "${./scripts/weather.sh}${locationArg}";
    interval = 900;
    return-type = "json";
    tooltip = true;
    format = "{text}";
  };

  style = ''
    #custom-weather {
      margin: 0 8px;
      padding: 0 10px;
      border-radius: 10px;
      transition: none;
      color: ${getColor "base09"};
      background: transparent;
    }
  '';
}
