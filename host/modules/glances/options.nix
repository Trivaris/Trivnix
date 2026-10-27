{ lib, ... }:
{
  options.hostPrefs.glances = {
    enable = lib.mkEnableOption "the Glances system monitoring API";
    port = lib.mkOption {
      type = lib.types.port;
      default = 61208;
      description = "TCP port on which the Glances API listens.";
    };
  };
}
