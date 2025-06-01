{
  inputs,
  ...
}:
{

  services.hyprpaper = {
    enable = true;
    settings = {
      interval = 600;
      splash = false;
      preload = [
        "${inputs.self}/resources/wp_1.jpg"
        "${inputs.self}/resources/wp_2.jpg"
        "${inputs.self}/resources/wp_3.jpg"
      ];
      wallpaper = [
        "eDP-1,${inputs.self}/resources/wp_1.jpg"
        "DP-1,${inputs.self}/resources/wp_1.jpg"
      ];
    };
  };

}
