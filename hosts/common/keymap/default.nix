{
  config,
  lib,
  ...
}:
let 
  cfg = config.hostPrefs;
in 
{

  options.hostPrefs.language = import ./config.nix {
    inherit (lib) types mkOption;
  };

  config = {
    console.keyMap = cfg.language.keyMap;

    i18n = 
      let
        language = "${cfg.language.locale}.${cfg.language.charset}";
        unitLanguage = "${cfg.language.units}.${cfg.language.charset}";
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
      extraLocaleSettings = builtins.listToAttrs( map(unit: {
        name = unit;
        value = unitLanguage;
      }) unitTypes );
    };

    services.xserver.xkb = {
      layout = cfg.language.keyMap;
      variant = "";
    };
  };
}
