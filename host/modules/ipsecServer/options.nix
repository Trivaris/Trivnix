{ lib, ... }:
{
  options.hostPrefs.ipsecServer = {
    enable = lib.mkEnableOption "Enable WireGuard server configuration.";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "FQDN of the vpn";
    };

    caCert = lib.mkOption {
      type = lib.types.str;
      description = "Path to the CA Certificate";
    };

    cert = lib.mkOption {
      type = lib.types.str;
      description = "Path to the Server Certificate";
    };

    clientCerts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra Certs you want allowed";
    };

    fullchain = lib.mkOption {
      type = lib.types.str;
      description = "Path to your fullchain.pem";
    };
  };
}
