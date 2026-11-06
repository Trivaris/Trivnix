{
  flake.nixosModules.desktop =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    let
      prefs = config.hostPrefs;
      mainuser = config.users.users.${prefs.mainUser};
      mainuserGroup = config.users.groups.${mainuser.group};
    in
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      environment.systemPackages = [
        pkgs.ntfs3g
        pkgs.sshfs
      ];
      nixpkgs.hostPlatform = lib.mkDefault config.hostInfos.architecture;
      system.stateVersion = config.hostInfos.stateVersion;

      powerManagement.cpuFreqGovernor = "performance";

      networking.hostName = config.hostInfos.name;
      networking.interfaces.eno1.wakeOnLan.enable = true;
      networking.networkmanager.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];
      services.fstrim.enable = true;
      services.fwupd.enable = true;

      boot.kernelModules = [
        "kvm-amd"
        "uinput"
      ];
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
      boot.initrd = {
        supportedFilesystems.ntfs = true;
        kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "btusb"
          "tpm_tis"
          "tpm_crb"
        ];
      };

      hardware.enableAllFirmware = true;
      hardware.uinput.enable = true;
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.nvidia.powerManagement.enable = true;
      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.open = true;
      hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
      };
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          Experimental = true;
          FastConnectable = true;
        };
      };

      fileSystems."/mnt/windows" = {
        device = "/dev/disk/by-id/nvme-eui.000000000000000100a07521311ee292-part2";
        fsType = "ntfs-3g";
        options = [
          "rw"
          "windows_names"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=007"
          "dmask=007"
        ];
      };

      fileSystems."/mnt/steamdeck" = {
        device = "deck@steamdeck.fritz.box:/home/deck";
        fsType = "fuse.sshfs";
        options = [
          "x-systemd.automount"
          "noauto"

          "_netdev"
          "reconnect"
          "ServerAliveInterval=15"

          "IdentityFile=${
            if prefs.openssh.enable then
              config.sops.secrets.ssh-host-key.path
            else
              prefs.sops.secrets.ssh-root-key.path
          }"
          "allow_other"
          "umask=000"

          "uid=${toString mainuser.uid}"
          "gid=${toString mainuserGroup.gid}"
        ];
      };

      fileSystems."/mnt/steamdeck-sdcard" = {
        device = "deck@steamdeck.fritz.box:/run/media/deck/steamdeck";
        fsType = "fuse.sshfs";
        options = [
          "x-systemd.automount"
          "noauto"

          "_netdev"
          "reconnect"
          "ServerAliveInterval=15"

          "IdentityFile=${
            if prefs.openssh.enable then
              config.sops.secrets.ssh-host-key.path
            else
              prefs.sops.secrets.ssh-root-key.path
          }"
          "allow_other"
          "umask=000"

          "uid=${toString mainuser.uid}"
          "gid=${toString mainuserGroup.gid}"
        ];
      };
    };

}
