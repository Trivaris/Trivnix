{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  prefs = config.userPrefs;
in
{
  options.userPrefs.lutris.enable = mkEnableOption ''
    Toggle installation of the Lutris client via Home Manager.
    Enable this when you want curated launchers for non-Steam games.
  '';

  config = mkIf prefs.lutris.enable {
    home.packages = [ pkgs.lutris ];
  };
}
