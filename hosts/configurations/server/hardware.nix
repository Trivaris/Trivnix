{
  config,
  lib,
  libExtra,
  modulesPath,
  hostconfig,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    libExtra.partition-layouts.server
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci_renesas"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostconfig.name;
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault hostconfig.architecture;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = hostconfig.stateVersion;

}
