{ ... }:
{

  imports = [
    ../common
    ./disko-config.nix
    ./hardware-configuration.nix
    ./system-packages.nix
    ./configuration.nix
    ./keymap.nix
  ];

}
