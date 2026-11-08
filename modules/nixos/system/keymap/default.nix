{
  flake.nixosModules.system-keymap =
    { config, lib, ... }:
    let
      languagePreferences = config.host.preferences.language;
    in
    {
      config = {
        console.keyMap = languagePreferences.keyMap;

        i18n =
          let
            language = "${languagePreferences.locale}.${languagePreferences.charset}";
            unitLanguage = "${languagePreferences.units}.${languagePreferences.charset}";
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
          layout = languagePreferences.keyMap;
          variant = "";
        };
      };
    };
}
