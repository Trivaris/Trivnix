{ inputs, ... }:
{

  imports = [
    ./hardware.nix
    ./configuration.nix
    ../common
    ../modules
  ];

  config.nixosModules = {
    android-emulator = true;
    custom-packages = true;
    fish = true;
    openssh = true;
  };

  config.sshPort = 2222;

}
