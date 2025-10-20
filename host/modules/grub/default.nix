{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.grub = import ./options.nix { inherit (lib) mkEnableOption; };
  config = mkIf prefs.grub.enable {
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
