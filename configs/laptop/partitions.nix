{
  disko.devices.disk.nixos = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-eui.6479a7855a309eb2";
    content.type = "gpt";

    content.partitions = {
      boot = {
        name = "ESP";
        size = "512M";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          extraArgs = [ "-F32" ];
          mountOptions = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

      swap = {
        name = "encryptedSwap";
        size = "16G";
        content = {
          type = "swap";
          randomEncryption = true;
          priority = 100;
        };
      };

      root = {
        name = "root";
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };
}
