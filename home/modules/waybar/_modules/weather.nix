{
  config,
  osConfig,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  theme = osConfig.themingPrefs.scheme;
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
      color: ${theme.base09};
    }
  '';
}
