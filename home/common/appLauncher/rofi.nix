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
  config = mkIf (prefs.appLauncher == "rofi") {
    programs.rofi.enable = true;
    wayland.windowManager.hyprland.settings.bind = [ "$mod, SPACE, exec, rofi -show drun" ];
  };
}
