{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.grub.enable {
    stylix.targets.grub.useWallpaper = true;
    boot = {
      loader.grub.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=0"
      ];
    };
  };
}
