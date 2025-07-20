{
  lib,
  libExtra,
  hostconfig,
  ...
}:
{

  imports = [
    libExtra.partition-layouts.none
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault hostconfig.architecture;

  system.stateVersion = hostconfig.stateVersion;

}
