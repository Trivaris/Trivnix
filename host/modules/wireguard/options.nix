{
  lib,
  ...
}:
{
  options.hostPrefs.wireguard = {
    enable = lib.mkEnableOption "a WireGuard client connection";

    port = lib.mkOption {
      type = lib.types.port;
      default = 51820;
      description = "UDP port used by the WireGuard interface.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1/24";
      description = "Address and prefix assigned to the WireGuard interface.";
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
      description = "Name of the WireGuard network interface.";
    };

    peers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            publicKey = lib.mkOption {
              type = lib.types.str;
              description = "Public key identifying the WireGuard peer.";
            };
            allowedIPs = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "IP ranges routed through this peer.";
            };
            endpoint = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Optional endpoint address and port for the peer.";
            };
            persistentKeepalive = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Optional keepalive interval in seconds for NAT traversal.";
            };
          };
        }
      );
      description = "WireGuard peers and the traffic routed through each peer.";
    };
  };
}
