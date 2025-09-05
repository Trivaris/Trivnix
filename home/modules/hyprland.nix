{
  hostPrefs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
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
        "$alt_mod" = "ALT";

        bind = [
          "$mod, Q, killactive"

          # Focus window in direction
          "$mod, LEFT,  movewindow, l"
          "$mod, RIGHT, movewindow, r"
          "$mod, UP,    movewindow, u"
          "$mod, down,  movewindow, d"

          # Send window to monitor in direction
          "$mod SHIFT, LEFT,  movewindow, mon:l"
          "$mod SHIFT, RIGHT, movewindow, mon:r"
          "$mod SHIFT, UP,    movewindow, mon:u"
          "$mod SHIFT, DOWN,  movewindow, mon:d"

          # Focus window in direction
          "$alt_mod, LEFT,  movefocus, l"
          "$alt_mod, RIGHT, movefocus, r"
          "$alt_mod, UP,    movefocus, u"
          "$alt_mod, DOWN,  movefocus, d"

          # Focus window on monitor in direction
          "$alt_mod SHIFT, LEFT,  focusmonitor, l"
          "$alt_mod SHIFT, RIGHT, focusmonitor, r"
          "$alt_mod SHIFT, UP,    focusmonitor, u"
          "$alt_mod SHIFT, DOWN,  focusmonitor, d"
        ];
      };

      plugins = [

      ];
    };
  };
}
