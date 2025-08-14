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
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostInfos.name;
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault hostInfos.architecture;
  system.stateVersion = hostInfos.stateVersion;
}