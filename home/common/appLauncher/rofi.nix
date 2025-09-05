{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.appLauncher.name == "rofi") {
    programs.rofi.enable = true;
    userPrefs.appLauncher.flags = "-show drun";
  };
}
