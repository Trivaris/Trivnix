{
  pkgs, 
  ...
}: {

  imports = [
    ./wayland.nix
    ./hyprland
    ./fonts.nix
  ];

  home.packages = with pkgs; [

  ];
  
}
