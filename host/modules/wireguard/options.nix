{
  lib,
  ...
}:
{
  options = {
    hostPrefs.wireguard.server = {
      enable = lib.mkEnableOption "Enable the Wireguard Server";
      domain = lib.mkOption { type = lib.types.str; };
      port = lib.mkOption {
        type = lib.types.port;
        default = 51820;
      };
      networkInterface = lib.mkOption {
        type = lib.types.str;
        default = "enp1s0";
      };
    };

    hostPrefs.wireguard.client = {
      enable = lib.mkEnableOption "Enable the Wireguard Client";
      ip = lib.mkOption { type = lib.types.str; };
      serverConfigname = lib.mkOption {
        type = lib.types.str;
        default = "server";
      };
      serverAddress = lib.mkOption { type = lib.types.str; };
      port = lib.mkOption {
        type = lib.types.port;
        default = 51820;
      };
    };
  };
}
