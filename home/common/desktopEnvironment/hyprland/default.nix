{
  config,
  lib,
  pkgs,
  hostInfos,
  trivnixLib,
  ...
}:
let
  inherit (lib)
    mkIf
    pipe
    mapAttrs
    flatten
    mergeAttrsList
    concatStringsSep
    ;

  prefs = config.userPrefs;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
  visual = import ./visual.nix { inherit lib getColor; };

  keybinds = mapAttrs (_: value: flatten (builtins.attrValues value)) (
    import ./keybinds.nix config lib
  );

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
    mergeAttrsList
  ];

  waybarStyle = pipe waybar [
    (map (module: module.style))
    (concatStringsSep "\n")
  ];
in
{
  options.userPrefs.hyprland = import ./options.nix lib;

  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.variables = [ "--all" ];

      settings = {
        inherit (hostInfos) monitor;
        binds.drag_threshold = 10;
        "$mod" = "SUPER";
        "$alt_mod" = "ALT";
      }
      // visual
      // keybinds;
    };

    vars.desktopEnvironmentBinary = "${pkgs.hyprland}/bin/Hyprland";
    stylix.targets.hyprland.enable = false;

    home.packages = builtins.attrValues {
      inherit (pkgs)
        python313
        playerctl
        light
        brightnessctl
        bluez
        hyprshot
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

    services.swaync = {
      enable = true;
      settings = {
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        positionX = "right";
        positionY = "top";
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = prefs.hyprland.wallpapers;
        wallpaper = map (path: ",${path}") prefs.hyprland.wallpapers;
        splash = false;
      };
    };
  };
}
