{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.grub.enable {
    boot = {
      loader.grub.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=0"
      ];
    };
  };
}
