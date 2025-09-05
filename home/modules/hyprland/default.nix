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
        "$mod" = "SUPER";

        bind = [
          "$mod, RETURN,  exec, ${prefs.terminalEmulator}"
          "$mod, B,       exec, ${builtins.head prefs.browsers}"
          "$mod, SPACE,   exec, ${prefs.appLauncher.name} ${prefs.appLauncher.flags}"
          "$mod, Q,       killactive"
        ];
      };

      plugins = [

      ];
    };
  };
}
