{
  config,
  lib,
  modulesPath,
  hostInfos,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostInfos.name;
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault hostInfos.architecture;
  system.stateVersion = hostInfos.stateVersion;
}
