{ lib, ... }:
{
  options.hostPrefs.ipsecClient = {
    enable = lib.mkEnableOption "Enable Strongswan client configuration.";

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
      description = "Path of your client cert";
    };

    id = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Id of the client specified in the client cert and key";
    };
  };
}
