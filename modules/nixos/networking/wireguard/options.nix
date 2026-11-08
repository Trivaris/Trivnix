{
  flake.nixosModules.networking-wireguard =
    { lib, ... }:
    let
      wgNodeSubmodule = lib.types.submodule {
        options = {
          id = lib.mkOption {
            type = lib.types.int;
            description = "The last octet of the 10.0.0.X IP address.";
          };
          publicKeyFile = lib.mkOption {
            type = lib.types.pathInStore;
            description = "Public key identifying the WireGuard peer";
          };
          isServer = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this node acts as the central routing server.";
          };
          endpoint = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional endpoint address and port for the peer (Required if isServer = true)";
          };
        };
      };
    in
    {
      options = {
        host.preferences.wireguard = {
          enable = lib.mkEnableOption "WireGuard client connection";

          port = lib.mkOption {
            type = lib.types.port;
            default = 51820;
            description = "UDP port used by the WireGuard interface";
          };

          subnetMask = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "Subnet Mask of the vpn subnet";
          };

          subnet = lib.mkOption {
            type = lib.types.str;
            default = "10.0.0.0";
            description = "Subnet ip addr of the vpn";
          };

          interfaceName = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = "wg0";
            description = "Name of the WireGuard network interface";
          };

          nodes = lib.mkOption {
            type = lib.types.attrsOf wgNodeSubmodule;
            default = { };
            description = "Global WireGuard network topology mapping confignames to their VPN configurations.";
          };
        };
      };
    };
}
