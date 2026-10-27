{ lib, ... }:
{
  options.hostPrefs.grub.enable = lib.mkEnableOption "GRUB customization";
}
