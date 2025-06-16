{ ... }:
{

  imports = [
    ./services/bluetooth.nix
    ./services/openssh.nix
    ./services/printing.nix

    ./custom-packages.nix
    ./fish.nix
    ./hyprland.nix
  ];

}
