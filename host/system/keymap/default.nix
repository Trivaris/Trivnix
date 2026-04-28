{ config, lib, ... }:
let
  languagePrefs = config.hostPrefs.language;
in
{
  config = {
    console.keyMap = languagePrefs.keyMap;

    i18n =
      let
        language = "${languagePrefs.locale}.${languagePrefs.charset}";
        unitLanguage = "${languagePrefs.units}.${languagePrefs.charset}";
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
      layout = languagePrefs.keyMap;
      variant = "";
    };
  };
}
