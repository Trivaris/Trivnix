{ lib, ... }:
{
  options.hostPrefs.grub.enable = lib.mkEnableOption "Enable GRUB Customization";
}
