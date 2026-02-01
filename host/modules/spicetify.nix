{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
  themePrefs = config.themingPrefs;
in
{
  options.spicetify.enable = lib.mkEnableOption "Enable Spotify";
  config = lib.mkIf prefs.spicetify.enable {
    programs.spicetify = {
      enable = true;
      theme = themePrefs.themes.spicetify;
      scheme = themePrefs.schemes.spicetify;
    };
  };

}