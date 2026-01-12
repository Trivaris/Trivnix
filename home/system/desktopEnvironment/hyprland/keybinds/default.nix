{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf (prefs.desktopEnvironment == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      bind.drag_threshold = 10;
      "$mod" = "SUPER";
      "$alt_mod" = "ALT";
      "$alt_gr_mod" = "ALT_R";
    }
    // (lib.mapAttrs (_: value: lib.flatten (builtins.attrValues value)) (
      import ./_binds.nix { inherit config lib; }
    ));
  };
}
