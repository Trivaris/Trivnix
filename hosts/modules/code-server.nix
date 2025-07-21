{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{

  options.nixosConfig.codeServer = {
    enable = mkEnableOption "Enable code-server (VS Code in the browser).";

    port = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Local port that code-server listens on.
        Typically proxied by a reverse proxy like Nginx.
      '';
    };

    externalPort = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Optional override for the externally exposed port.
        If unset, defaults to the reverse proxy's global port.
      '';
    };

    internalIP = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Internal IP address the service binds to.
        Use "127.0.0.1" for localhost-only access or "0.0.0.0" to listen on all interfaces.
      '';
    };

    domain = mkOption {
      type = types.str;
      example = "code.example.com";
      description = ''
        FQDN used for external access to code-server.
        Used in reverse proxy configuration and certificate provisioning.
      '';
    };
  };

  config = mkIf cfg.codeServer.enable {
    services.code-server = {
      enable = true;
      port = cfg.codeServer.port;
      host = "127.0.0.1";
      user = "trivaris";
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
    
}
