{
  osConfig,
  lib,
  pkgs,
  ...
}@inputs:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings = {
      bind.drag_threshold = 10;
      "$mod" = "SUPER";
      "$alt_mod" = "ALT";
      "$alt_gr_mod" = "ALT_R";
    }
    // (lib.mapAttrs (_: value: lib.flatten (builtins.attrValues value)) (import ./_binds.nix inputs));
  };
}
