{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable WireGuard server configuration.";
  asClient = mkEnableOption "If you do not want to host the server, but connect to it";

  domain = mkOption {
    type = types.str;
    description = "FQDN of the vpn";
  };

  clientCert = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "Path of your client cert";
  };

  clientId = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "Id of the client specified in the client cert and key";
  };
}
