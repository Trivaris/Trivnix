{

  fileSystems."/lib/modules/6.6.87.1-microsoft-standard-WSL2" = {
    device = "none";
    fsType = "overlay";
  };

  fileSystems."/mnt/wsl" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/usr/lib/wsl/drivers" = {
    device = "drivers";
    fsType = "9p";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0e67663d-513c-4853-8b9b-82410f66a768";
    fsType = "ext4";
  };

  fileSystems."/mnt/wslg" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/mnt/wslg/distro" = {
    device = "";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/usr/lib/wsl/lib" = {
    device = "none";
    fsType = "overlay";
  };

  fileSystems."/tmp/.X11-unix" = {
    device = "/mnt/wslg/.X11-unix";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/mnt/c" = {
    device = "C:\134";
    fsType = "9p";
  };

  fileSystems."/mnt/wslg/doc" = {
    device = "none";
    fsType = "overlay";
  };

  fileSystems."/mnt/d" = {
    device = "D:\134";
    fsType = "9p";
  };

  fileSystems."/mnt/wslg/run/user/1000" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/7016bd60-4a0e-48e6-99c7-8adfdebbf309"; }
  ];

}