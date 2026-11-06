{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.system-keymap =
    { config, lib, ... }:
    let
      language-prefs = config.host-prefs.language;
    in
    {
      config = {
        console.keyMap = language-prefs.keyMap;

        i18n =
          let
            language = "${language-prefs.locale}.${language-prefs.charset}";
            unitLanguage = "${language-prefs.units}.${language-prefs.charset}";
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
          layout = language-prefs.keyMap;
          variant = "";
        };
      };
    };
}
