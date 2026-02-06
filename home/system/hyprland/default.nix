{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.userPrefs.weatherLocation = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = ''
      Location query passed to the Waybar weather script (e.g. ``"berlin"`` or ``"48.85,2.35"``).
      Leave ``null`` to let wttr.in detect the location automatically from the current IP address.
    '';
  };

  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland = {
      enable = true;
      settings.input.kb_layout = osConfig.hostPrefs.language.keyMap or "us";
      settings.exec-one = [
        "hyprpaper"
        "swaync"
      ];
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

        nautilus
        loupe
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
