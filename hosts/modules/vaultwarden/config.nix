{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable the Vaultwarden password manager server.";

  port = mkOption {
    type = types.port;
    default = 8891;
    description = ''
      Local port Vaultwarden binds to.
      This is typically proxied behind Nginx and should not be publicly exposed directly.
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
    example = "vault.example.com";
    description = ''
      FQDN used to access Vaultwarden externally.
      Used for setting the DOMAIN environment variable and ACME certificate configuration.
    '';
  };
}
