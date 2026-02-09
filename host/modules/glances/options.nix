{ lib, ... }:
{
  options.hostPrefs.glances = {
    enable = lib.mkEnableOption "Enable the Glances API";
    port = lib.mkOption {
      type = lib.types.port;
      default = 61208;
    };
  };
}
