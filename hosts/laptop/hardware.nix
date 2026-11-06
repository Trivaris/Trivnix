{
  flake.nixosModules.laptop =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      nixpkgs.hostPlatform = lib.mkDefault config.hostInfos.architecture;
      system.stateVersion = config.hostInfos.stateVersion;
      systemd.tmpfiles.rules = [
        "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
      ];

      powerManagement.enable = true;
powerManagement.powertop.enable = true;

      networking.hostName = config.hostInfos.name;
      networking.networkmanager.enable = true;

      services.power-profiles-daemon.enable = false;
      services.fstrim.enable = true;
      services.fwupd.enable = true;
      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
            energy_performance_preference = "power";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModprobeConfig = ''
        options rtw89_pci disable_aspm=n
        options rtw89_core disable_ps_mode=n
      '';
      boot.kernelParams = [
        "amd_pstate=active"
        "nvme.noacpi=1"
        "ahci.mobile_lpm_policy=3"
        "rtc_cmos.use_acpi_alarm=1"
      ];

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.graphics.enable = true;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General = {
          Experimental = false;
          FastConnectable = true;
        };
      };
    };
}
