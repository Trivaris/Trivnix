{
  pkgs, 
  ...
}: {

  imports = [
    ./wayland.nix
    ./hyprland
  ];

  home.packages = with pkgs; [

  ];
  
}
