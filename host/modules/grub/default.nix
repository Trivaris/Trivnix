{ config, lib, ... }:
let
  grubPrefs = config.hostPrefs.grub;
in
{
  config = lib.mkIf grubPrefs.enable {
    boot = {
      loader.grub.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=0"
      ];
    };
  };
}
