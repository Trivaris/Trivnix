{
  lib,
  architecture,
  stateVersion,
  ...
}:
{

  imports = [
    # ../common/core/hardware/wsl.nix
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault architecture;

  system.stateVersion = stateVersion;

}
