{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable Strongswan client configuration.";

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
    description = "Path of your client cert";
  };

  id = mkOption {
    type = types.nullOr types.str;
    description = "Id of the client specified in the client cert and key";
  };
}
