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
    # libExtra.partition-layouts.disko-default
  ];

  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostconfig.name;
  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault hostconfig.architecture;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = hostconfig.stateVersion;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/54d85da4-4452-4cba-89b2-eae6bc71d635";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A39C-EE6D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

}
