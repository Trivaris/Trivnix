{ lib, ... }:
{
  options.userPrefs.librewolf = {
    enable = lib.mkEnableOption "LibreWolf";
    allowedCookies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "https://accounts.google.com" ];
      description = "Sites whose cookies are preserved when the browser closes.";
    };
  };
}
