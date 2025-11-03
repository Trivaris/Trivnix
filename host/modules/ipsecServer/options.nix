{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.hostPrefs.ipsecServer = {
    enable = lib.mkEnableOption "Enable WireGuard server configuration.";

    domain = mkOption {
      type = types.str;
      description = "FQDN of the vpn";
    };

    caCert = mkOption {
      type = types.str;
      description = "Path to the CA Certificate";
    };

    cert = mkOption {
      type = types.str;
      description = "Path to the Server Certificate";
    };

    extraClientCerts = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra Certs you want allowed";
    };

    fullchain = mkOption {
      type = types.str;
      description = "Path to your fullchain.pem";
    };
  };
}
