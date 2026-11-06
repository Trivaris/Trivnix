{
  flake.nixosModules.server =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      nixpkgs.hostPlatform = lib.mkDefault config.hostInfos.architecture;
      system.stateVersion = config.hostInfos.stateVersion;

      services.qemuGuest.enable = true;
      services.fstrim.enable = true;

      networking.hostName = config.hostInfos.name;
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager.enable = false;

      boot.initrd.availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "virtio_blk"
        "sd_mod"
        "sr_mod"
      ];

      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
      boot.kernelParams = [ "console=ttyS0,115200n8" ];
      boot.extraModulePackages = [ ];
      boot.loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
}
