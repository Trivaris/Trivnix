{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = {
    console.keyMap = prefs.language.keyMap;

    i18n =
      let
        language = "${prefs.language.locale}.${prefs.language.charset}";
        unitLanguage = "${prefs.language.units}.${prefs.language.charset}";
        unitTypes = [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ];
      in
      {
        defaultLocale = language;
        extraLocaleSettings = builtins.listToAttrs (
          map (unit: lib.nameValuePair unit unitLanguage) unitTypes
        );
      };

    services.xserver.xkb = {
      layout = prefs.language.keyMap;
      variant = "";
    };
  };
}
