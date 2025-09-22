{
  config,
  lib,
  pkgs,
  hostInfos,
  hostPrefs,
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
    replaceStrings
    sort
    splitString
    ;

  prefs = config.userPrefs;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
  visual = import ./visual.nix { inherit lib getColor; };

  monitorStrings = hostInfos.monitor or [ ];

  parseMonitor =
    monitor:
    let
      parts = splitString "," monitor;
      namePart = builtins.head parts;
      positionPart = if builtins.length parts > 2 then builtins.elemAt parts 2 else "0x0";
      coords = splitString "x" positionPart;
      xString = builtins.head coords;
      sanitized = replaceStrings [ "+" ] [ "" ] xString;
    in
    {
      name = namePart;
      x = builtins.fromJSON sanitized;
    };

  parsedMonitors = map parseMonitor monitorStrings;
  sortedMonitors = sort (a: b: a.x < b.x) parsedMonitors;
  monitorCount = builtins.length sortedMonitors;
  middleIndex = if monitorCount == 0 then 0 else builtins.div (monitorCount - 1) 2;

  mainMonitorName =
    if monitorCount == 0 then "" else (builtins.elemAt sortedMonitors middleIndex).name;

  hyprlock = import ./hyprlock.nix {
    inherit mainMonitorName;
  };

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
        (map (
          module:
          module {
            inherit
              config
              getColor
              lib
              hostPrefs
              ;
          }
        ))
      ];

  waybarSettings = mergeAttrsList (map (module: module.settings) waybar);
  waybarStyle = concatStringsSep "\n" (map (module: module.style) waybar);
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

    programs = {
      waybar = {
        enable = true;
        style = waybarStyle;
        settings.mainBar = waybarSettings;

        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };

      hyprlock = {
        enable = true;
        settings = hyprlock;
      };
    };

    services = {
      hypridle.enable = true;

      swaync = {
        enable = true;
        settings = {
          layer = "overlay";
          control-center-layer = "top";
          layer-shell = true;
          positionX = "right";
          positionY = "top";
        };
      };

      hyprpaper = {
        enable = true;
        settings = {
          preload = prefs.hyprland.wallpapers;
          wallpaper = map (path: ",${path}") prefs.hyprland.wallpapers;
          splash = false;
        };
      };
    };
  };
}
