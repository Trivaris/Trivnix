{
  disko.devices.disk.nixos = {
    type = "disk";
    device = "/dev/nvme1n1";
    content.type = "gpt";
    content.partitions = {
      boot = {
        type = "partition";
        start = "1MiB";
        end = "512MiB";
        bootable = true;
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "fmask=0077" "dmask=0077" ];
        };
      };

      root = {
        type = "partition";
        start = "512MiB";
        end = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };
}
