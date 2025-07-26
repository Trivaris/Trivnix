lib:
with lib;
{
  enable = mkEnableOption "Enable the Suwayomi server (Tachidesk) service.";
  
  port = mkOption {
    type = types.port;
    default = 8890;
    description = ''
      Local port the Suwayomi server listens on.
      This is proxied by Nginx or another reverse proxy for external access.
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
    example = "manga.example.com";
    description = ''
      Fully qualified domain name (FQDN) for reverse proxy access to Suwayomi.
      Used to configure virtual hosts and TLS certificates.
    '';
  };
}