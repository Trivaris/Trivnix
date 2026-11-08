{
  flake.homeModules.desktop-environment-hyprland =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (!osConfig.host.preferences.headless) {
        wayland.windowManager.hyprland = {
          enable = true;
          portalPackage = null;
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

        home.packages = [
          pkgs.python313
          pkgs.playerctl
          pkgs.pwvucontrol
          pkgs.nmgui
          pkgs.brightnessctl
          pkgs.networkmanagerapplet
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
    };
}
