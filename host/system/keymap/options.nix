{ lib, ... }:
{
  options.hostPrefs.language = {
    keyMap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = ''
        Console keyboard layout applied to virtual terminals and X11.
        Match this with the desired XKB layout string (e.g., `us`, `de`).
      '';
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US";
      description = ''
        Primary locale controlling interface language and formatting rules.
        Used for `i18n.defaultLocale` and influences system-wide translations.
      '';
    };

    charset = lib.mkOption {
      type = lib.types.str;
      default = "UTF-8";
      description = ''
        Character set appended to locale definitions, typically `UTF-8`.
        Adjust only when targeting non-Unicode encodings for legacy software.
      '';
    };

    units = lib.mkOption {
      type = lib.types.str;
      default = "de_DE";
      description = ''
        Locale responsible for measurement units and region-specific formats.
        Populates the LC_* overrides for numbers, dates, and other unit settings.
      '';
    };
  };
}
