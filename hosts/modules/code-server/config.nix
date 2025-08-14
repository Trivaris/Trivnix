{
  mkEnableOption,
  types,
  mkOption,
}:
{
  enable = mkEnableOption "Enable code-server (VS Code in the browser).";

  port = mkOption {
    type = types.port;
    default = 8888;
    description = ''
      Local port that code-server listens on.
      Typically proxied by a reverse proxy like Nginx.
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
      IP address the service binds to.
      Use "127.0.0.1" for localhost-only access or "0.0.0.0" to listen on all interfaces.
    '';
  };

  domain = mkOption {
    type = types.str;
    example = "code.example.com";
    description = ''
      FQDN used for external access to code-server.
      Used in reverse proxy config and certificate provisioning.
    '';
  };
}
