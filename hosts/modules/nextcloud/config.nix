{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable the Nextcloud service.";

  port = mkOption {
    type = types.port;
    default = 8889;
    description = ''
      Local port Nextcloud will bind to.
      Typically used behind a reverse proxy and not exposed directly.
    '';
  };

  externalPort = mkOption {
    type = types.nullOr types.port;
    default = null;
    description = ''
      Optional override for the externally exposed port.
      If unset, defaults to the reverse proxy's global port.
    '';
  };

  ipAddress = mkOption {
    type = types.str;
    default = "127.0.0.1";
    description = ''
      Internal IP address the service binds to.
      Use "127.0.0.1" for localhost-only access or "0.0.0.0" to listen on all interfaces.
    '';
  };

  domain = mkOption {
    type = types.str;
    description = ''
      FQDN to access the Nextcloud instance.
      Used in web configuration and TLS certificate issuance.
    '';
    example = "cloud.example.com";
  };
}
