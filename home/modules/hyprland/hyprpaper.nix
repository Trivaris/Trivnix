{
  config,
  lib,
  lib-extra,
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
          (lib-extra.mkFlakePath /resources/wp_1.jpg)
          (lib-extra.mkFlakePath /resources/wp_2.jpg)
          (lib-extra.mkFlakePath /resources/wp_3.jpg)
        ];
        wallpaper = [
          "eDP-1,${toString (lib-extra.mkFlakePath /resources/wp_1.jpg)}"
          "DP-1,${toString (lib-extra.mkFlakePath /resources/wp_1.jpg)}"
        ];
      };
    };
  };

}
