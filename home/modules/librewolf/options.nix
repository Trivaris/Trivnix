{ lib, ... }:
{
  options.userPrefs.librewolf = {
    enable = lib.mkEnableOption "Enable Librewolf";
    allowedCookies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "https://accounts.google.com" ];
      description = "Sites to not clear when the browser is closed";
    };
  };
}
