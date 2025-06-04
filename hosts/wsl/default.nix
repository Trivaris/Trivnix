{ ... }:
{

  imports = [
    ../common
    ../../modules/nixos/hardware/wsl.nix
    #./hardware-configuration.nix
    ./configuration.nix
  ];

}
