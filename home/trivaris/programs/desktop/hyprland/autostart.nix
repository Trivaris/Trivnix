{
  lib,
  ...
}:
{

  wayland.windowManager.hyprland.settings = lib.mkMerge [
    {
      exec-once = [
        "waybar"
        "rm ~/.vscodium-server/bin/*/node"
        "ln -s $(which node) ~/.vscodium-server/bin/*/node"
      ];
    }
  ];

}
