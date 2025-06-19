{
  hostname,
  config,
  lib,
  modulesPath,
  architecture,
  stateVersion,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    config.drive-layouts.disko-default
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

  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault architecture;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = stateVersion;

}
