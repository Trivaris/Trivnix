{
  config,
  inputs,
  lib,
  ...
}:
with lib;
{

  config = mkIf config.homeModules.hyprland {
    services.hyprpaper = {
      enable = true;
      settings = {
        interval = 600;
        splash = false;
        preload = [
          (libExtra.mkFlakePath /resources/wp_1.jpg)
          (libExtra.mkFlakePath /resources/wp_2.jpg)
          (libExtra.mkFlakePath /resources/wp_3.jpg)
        ];
        wallpaper = [
          "eDP-1,${toString (libExtra.mkFlakePath /resources/wp_1.jpg)}"
          "DP-1,${toString (libExtra.mkFlakePath /resources/wp_1.jpg)}"
        ];
      };
    };
  };

}
