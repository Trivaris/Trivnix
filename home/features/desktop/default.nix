{
  pkgs, 
  ...
}: {

  imports = [
    ./wayland.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [

  ];
  
}
