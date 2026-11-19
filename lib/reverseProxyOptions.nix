{
  mkEnableOption,
  mkOption,
  types,
  ...
}:
{
  options = {
    enable = mkEnableOption "Reverse Proxy";
    enableAnubis = mkEnableOption "Anubis";
    https = mkEnableOption "Routing through https behind the reverse proxy for service";

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The internal ip address of the service";
    };

    port = mkOption {
      type = types.port;
      description = "Internal service port.";
    };

    domain = mkOption {
      type = types.str;
      example = "service.example.com";
      description = "Domain for the service.";
    };

    externalPort = mkOption {
      type = types.int;
      default = 443;
      description = "External port for the service.";
    };

    allowFrom = mkOption {
      type = types.nullOr (types.nonEmptyListOf types.str);
      default = null;
      description = "CIDR addresses to allow";
    };
  };
}
