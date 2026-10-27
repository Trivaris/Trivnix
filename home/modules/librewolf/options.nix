{ lib, ... }:
{
  options.userPrefs.librewolf = {
    enable = lib.mkEnableOption "LibreWolf, a privacy focused Browser";
    allowedCookies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "https://accounts.google.com" ];
      description = "Sites whose cookies are preserved when the browser closes";
    };
  };
}
