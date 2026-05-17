{
  config,
  lib,
  pkgs,
  ...
}:
let
  spotifyPrefs = config.hostPrefs.spotify;
  themePrefs = config.themingPrefs;
in
{
  options.hostPrefs.spotify = {
    enable = lib.mkEnableOption "Spotify";
    spicetify.enable = lib.mkEnableOption "Spicetify Theming";
  };
  config = lib.mkIf spotifyPrefs.enable {
    environment.systemPackages = if !spotifyPrefs.spicetify.enable then [ pkgs.spotify ] else [ ];
    
    programs.spicetify = lib.mkIf spotifyPrefs.spicetify.enable {
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
