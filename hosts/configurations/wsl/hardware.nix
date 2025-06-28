{
  lib,
  architecture,
  stateVersion,
  lib-extra,
  ...
}:
{

  imports = [
    lib-extra.partition-layouts.none
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault architecture;

  system.stateVersion = stateVersion;

}
