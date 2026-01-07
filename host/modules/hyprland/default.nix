{
  allUserPrefs,
  lib,
  ...
}:
let
  inherit (lib) mkIf pipe;
in
{
  config =
    mkIf
      (pipe allUserPrefs [
        builtins.attrValues
        (map (prefs: prefs.desktopEnvironment or ""))
        (builtins.elem "hyprland")
      ])
      {
        security.pam.services.hyprlock = { };
        programs.hyprland.enable = true;
      };
}
