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

    allowedSubnets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "10.0.0.2/32" "192.168.10.0/24" ];
    };

    publicKeyFile = lib.mkOption {
      type = lib.types.path;
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };
  };
}
