{ lib, ... }:
{
  options.userPrefs.cli.enable = lib.mkEnableOption ''
    Replace selected default CLI utilities with the configured alternatives.
  '';
}
