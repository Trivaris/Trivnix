{ lib, ... }:
{
  options.userPrefs.librewolf = {
    betterfox = lib.mkEnableOption ''
      Merge the Betterfox hardening profile into LibreWolf's user.js.
      Enable when the Betterfox input is available and you want the tweaks applied.
    '';

    clearOnShutdown = lib.mkEnableOption ''
      Purge browsing data each time LibreWolf exits.
      Toggle this for extra privacy when using shared machines.
    '';

    allowedCookies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "https://accounts.google.com" ];
      description = ''
        Sites allowed to keep cookies even when `clearOnShutdown` is true.
        Provide full origins (scheme + host) to whitelist specific domains.
      '';
    };
  };
}
