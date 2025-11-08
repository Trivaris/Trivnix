{ lib, ... }:
{
  options.userPrefs.cli.enable = lib.mkEnableOption "Wether to replace default cli utils with better variants";
}
