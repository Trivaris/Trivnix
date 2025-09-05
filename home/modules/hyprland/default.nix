{
  hostPrefs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  binds = import ./keybinds.nix config |> builtins.attrValues |> lib.flatten;
  visual = import ./visual.nix;
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
        ]
        ++ binds;
      }
      // visual;

      plugins = [

      ];
    };
  };
}
