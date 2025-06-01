{
  lib,
  ...
}:
{

  wayland.windowManager.hyprland.settings = lib.mkMerge [
    {
      exec-once = [
        "waybar"
      ];
    }
  ];

}
