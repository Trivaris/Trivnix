{ ... }:
{

  imports = [
    ../common
    ./disko-config.nix
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/laptop.nix
    ./configuration.nix
  ];

}
