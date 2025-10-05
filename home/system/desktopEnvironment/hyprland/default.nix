{
  config,
  lib,
  pkgs,
  hostInfos,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  prefs = config.userPrefs;
  imports = trivnixLib.resolveDir {
    dirPath = ./.;
    preset = "importList";
  };
in
{
  inherit imports;

  options.userPrefs.hyprland = {
    wallpapers = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of image paths Hyprland cycles through as wallpapers.
        Provide absolute paths so the Hyprland module can copy them into place.
      '';
    };

    weatherLocation = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Location query passed to the Waybar weather script (e.g. ``"berlin"`` or ``"48.85,2.35"``).
        Leave ``null`` to let wttr.in detect the location automatically from the current IP address.
      '';
    };
  };

  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    vars.desktopEnvironmentBinary = "${pkgs.hyprland}/bin/Hyprland";
    stylix.targets.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.variables = [ "--all" ];
      settings.monitor = hostInfos.monitor;
    };

    home.packages = builtins.attrValues {
      inherit (pkgs)
        python313
        playerctl
        pwvucontrol
        nmgui
        brightnessctl
        networkmanagerapplet
        ;
    };

    programs = {
      hyprshot = {
        enable = true;
        saveLocation = "$HOME/Pictures/Screenshots";
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
