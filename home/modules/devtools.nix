{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.enableDevStuffs = lib.mkEnableOption "Enable Dev Stuffs lol";
  config = lib.mkIf prefs.enableDevStuffs {
    home.packages = [ pkgs.gradle_9 pkgs.kotlin-native pkgs.nixd pkgs.libGL ];
    programs.java = {
      enable = true;
      package = pkgs.openjdk21;
    };
  };
}
