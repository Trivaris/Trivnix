{
  config,
  pkgs,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
  theme = config.themingPrefs.spicetify.
in
{
  options.spicetify.enable = lib.mkEnableOption "Enable Spotify";
  config = lib.mkIf prefs.spicetify.enable {
    programs.spicetify = {
      enable = true;

    };
  };

}