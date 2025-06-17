{ inputs, ... }:
{

  imports = [
    ../common
    ../modules
    ./hardware.nix
  ];

  config.nixosModules = {
    bluetooth = true;
    custom-packages = true;
    fish = true;
    hyprland = true;
    openssh = true;
    printing = true;
  };

}
