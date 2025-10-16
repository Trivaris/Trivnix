{ config, lib, ... }:
let
  inherit (lib) mapAttrs flatten mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      bind.drag_threshold = 10;
      "$mod" = "SUPER";
      "$alt_mod" = "ALT";
      "$fn_mod" = "KEY_WAKEUP";
    }
    // (mapAttrs (_: value: flatten (builtins.attrValues value)) (
      import ./binds.nix { inherit config lib; }
    ));
  };
}
