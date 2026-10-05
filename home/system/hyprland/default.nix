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
      extraConfig = ''
        _G.reminderTimer = hl.timer(function()
          hl.notification.create({
            text = "1 hour has passed",
            timeout = 5000,
            type = "hint"
          })
        end, { timeout = 60 * 60 * 1000, type = "repeat" })
      '';
    };

    home.sessionVariables.QT_QPA_PLATFORMTHEME = "hyprqt6engine";
    home.packages = [
      pkgs.python313
      pkgs.playerctl
      pkgs.pwvucontrol
      pkgs.nmgui
      pkgs.brightnessctl
      pkgs.networkmanagerapplet
      pkgs.networkmanager-strongswan
      pkgs.strongswan
      pkgs.wtype
      pkgs.nautilus
      pkgs.loupe
      pkgs.hyprqt6engine
    ];

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
