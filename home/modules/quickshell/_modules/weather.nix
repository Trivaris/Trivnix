{
  config,
  osConfig,
  lib,
  ...
}:
let
  theme = osConfig.themingPrefs.scheme;
  location = config.userPrefs.weatherLocation;
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
