{ ... }:
{

  imports = [
    ./custom-packages.nix
    ./hyprland.nix
    ./wayland.nix
    ./services/bluetooth.nix
    ./services/openssh.nix
    ./services/printing.nix
  ];

}