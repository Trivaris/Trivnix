{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
  themePrefs = config.themingPrefs;
in
{
  options.hostPrefs.spicetify.enable = lib.mkEnableOption "Enable Spotify";
  config = lib.mkIf prefs.spicetify.enable {
    programs.spicetify = {
      enable = true;
      theme =
        if themePrefs.themeOverrides.spicetify != null then
          themePrefs.themeOverrides.spicetify.package
        else
          (import ./_theme.nix config pkgs);
      colorScheme =
        if themePrefs.themeOverrides.spicetify != null then
          themePrefs.themeOverrides.spicetify.scheme
        else
          "Custom";
    };
  };

}
