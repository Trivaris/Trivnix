{
  config,
  lib,
  pkgs,
  hostPrefs,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf pipe;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
  visual = import ./visual.nix { inherit lib getColor; };

  bind = pipe (import ./keybinds.nix config) [
    builtins.attrValues
    lib.flatten
  ];

  waybar =
    pipe
      {
        dirPath = ./waybar;
        flags = [
          "foldDefault"
          "onlyNixFiles"
          "collapse"
          "mapImports"
        ];
      }
      [
        trivnixLib.resolveDir
        builtins.attrValues
        (map (module: module { inherit getColor config; }))
      ];

  waybarSettings = pipe waybar [
    (map (module: module.settings))
    lib.mergeAttrsList
  ];

  waybarStyle = pipe waybar [
    (map (module: module.style))
    (lib.concatStringsSep "\n")
  ];
in
{
  config = mkIf (hostPrefs ? desktopEnvironment && hostPrefs.desktopEnvironment == "hyprland") {
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

    home.packages = builtins.attrValues {
      inherit (pkgs)
        python313
        playerctl
        light
        brightnessctl
        ;
    };

    programs.waybar = {
      enable = true;
      style = waybarStyle;
      settings.mainBar = waybarSettings;

      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ (trivnixLib.mkStorePath "resources/wallpaper3.png") ];
        wallpaper = [ ",${trivnixLib.mkStorePath "resources/wallpaper3.png"}" ];
        splash = false;
      };
    };
  };
}
