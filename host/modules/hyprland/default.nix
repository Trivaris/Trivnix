{
  lib,
  config,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config =
    lib.mkIf (!prefs.headless) {
      security.pam.services.hyprlock = { };
      programs.hyprland.enable = true;
    };
}
