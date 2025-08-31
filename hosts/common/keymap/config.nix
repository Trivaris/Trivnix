{
  types,
  mkOption,
}:
{
  keyMap = mkOption {
    type = types.str;
    default = "us";
    description = ''
      The keyboard mapping table for the virtual consoles.
    '';
  };

  locale = mkOption {
    type = types.str;
    default = "en_US";
    description = ''
      It determines the language for program messages, the format for dates and times, sort order, and so on.
    '';
  };

  charset = mkOption {
    type = types.str;
    default = "UTF-8";
    description = ''
      The locale character set.
    '';
  };

  units = mkOption {
    type = types.str;
    default = "de_DE";
    description = ''
      Determines the Language of the types of Units used.
    '';
  };
}
