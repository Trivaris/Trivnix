{
  config,
  osConfig,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  theme = osConfig.themingPrefs.theme;
  location = prefs.weatherLocation;
  locationArg = lib.optionalString (
    location != null && location != ""
  ) " ${lib.escapeShellArg location}";
in
{
  settings."custom/weather" = {
    exec = "${../scripts/weather.sh}${locationArg}";
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
      color: ${theme.base09};
      background: transparent;
    }
  '';
}
