{
  lib,
  ...
}:
{
  options.hostPrefs.wireguard = {
    enable = lib.mkEnableOption "Wireguard client connection";

    port = lib.mkOption {
      type = lib.types.port;
      default = 51820;
    };

    vpnSubnet = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1/24";
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };

    peers = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          publicKeyFile = lib.mkOption { type = lib.types.str; };
          allowedIPs = lib.mkOption { type = lib.types.listOf lib.types.str; };
        };
      });
    };
  };
}
