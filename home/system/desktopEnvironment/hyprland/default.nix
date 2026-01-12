{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs = {
    waybar.weatherLocation = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Location query passed to the Waybar weather script (e.g. ``"berlin"`` or ``"48.85,2.35"``).
        Leave ``null`` to let wttr.in detect the location automatically from the current IP address.
      '';
    };
  };

  config = lib.mkIf (prefs.desktopEnvironment == "hyprland") {
    vars.desktopEnvironmentBinary = "start-hyprland";

    stylix.targets.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      settings.exec-one = [
        "hyprpaper"
        "swaync"
      ];
      settings.input.kb_layout = osConfig.hostPrefs.language.keyMap or "us";
    };

    home.packages = builtins.attrValues {
      inherit (pkgs)
        python313
        playerctl
        pwvucontrol
        nmgui
        brightnessctl
        networkmanagerapplet
        networkmanager-strongswan
        strongswan
        wtype
        ;
    };

    programs.hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/Screenshots";
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
    };
  };
}
