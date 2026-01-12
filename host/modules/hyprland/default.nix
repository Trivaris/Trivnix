{
  allUserPrefs,
  lib,
  ...
}:
{
  config =
    lib.mkIf
      (lib.pipe allUserPrefs [
        builtins.attrValues
        (map (prefs: prefs.desktopEnvironment or ""))
        (builtins.elem "hyprland")
      ])
      {
        security.pam.services.hyprlock = { };
        programs.hyprland.enable = true;
      };
}
