{
  hostPrefs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (hostPrefs ? desktopEnvironment && hostPrefs.desktopEnvironment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.variables = [ "--all" ];

      settings = {
        inherit (hostPrefs.hyprland) monitor;
        "$mod" = "SUPER";

        bind = [
          "$mod, RETURN,  exec, ${prefs.terminalEmulator}"
          "$mod, Q,       killactive"
        ];
      };

      plugins = [

      ];
    };
  };
}
