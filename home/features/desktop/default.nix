{
  pkgs, 
  ...
}: {

  imports = [
    ./wayland.nix
    ./hyprland
    ./fonts.nix
  ];
  
}
