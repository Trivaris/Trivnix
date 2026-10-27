{ lib, ... }:
{
  options.userPrefs.cli.enable = lib.mkEnableOption "Replacement of selected default CLI utilities with the configured alternatives";
}
