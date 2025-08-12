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
    libExtra.partitionLayouts.desktop
  ];

  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostconfig.name;
  networking.networkmanager.enable = true;
  networking.interfaces.eno1.wakeOnLan.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault hostconfig.architecture;
  system.stateVersion = hostconfig.stateVersion;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    KERNEL=="event*", SUBSYSTEM=="input", GROUP="input", MODE="0660"
  '';
}
