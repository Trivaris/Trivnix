{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_102062030";

    content = {
      type = "table";
      format = "msdos";
      partitions = [
        {
          name = "boot";
          part-type = "primary";
          start = "1MiB";
          end = "512MiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/boot";
          };
        }
        {
          name = "swap";
          part-type = "primary";
          start = "512MiB";
          end = "4G";
          content = {
            type = "swap";
            priority = 100;
          };
        }
        {
          name = "root";
          part-type = "primary";
          start = "4.5GiB";
          end = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  };
}