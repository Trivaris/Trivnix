{ inputs, ... }:
{

  imports = [
    ./hardware.nix
    ./configuration.nix
    ../common
    ../modules
  ];

  config.nixosModules = {
    fish = true;
    openssh = true;
  };

  config.sshPort = 2222;

}
