{
  pkgs, 
  ...
}: {

  imports = [
    ./fonts.nix
    ./wayland.nix
    ./hyprland
    ./wezterm
    ./rofi.nix
  ];
  
}
