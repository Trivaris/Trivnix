{
  trivnixLib,
  hostPrefs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
  bind = import ./keybinds.nix config |> builtins.attrValues |> lib.flatten;
  visual = import ./visual.nix { inherit lib getColor; };
in
{
  config = mkIf (lib.hasAttrByPath [ "desktopEnvironment" "name" ] hostPrefs && hostPrefs.desktopEnvironment.name == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.variables = [ "--all" ];

      settings = {
        inherit bind;
        inherit (hostPrefs.hyprland) monitor;

        "$mod" = "SUPER";
        "$alt_mod" = "ALT";
      }
      // visual;
    };

    stylix.targets.hyprland.enable = false;
    programs.waybar.enable = true;

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ (trivnixLib.mkStorePath "resources/wallpaper2.png") ];
        wallpaper = [ ",${trivnixLib.mkStorePath "resources/wallpaper2.png"}" ];
        splash = false;
      };
    };
  };
}
