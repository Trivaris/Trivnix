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

  options.nixosConfig.vaultwarden = {
    enable = mkEnableOption "Enable the Vaultwarden password manager server.";

    port = mkOption {
      type = types.int;
      default = 8891;
      description = ''
        Local port Vaultwarden binds to.
        This is typically proxied behind Nginx and should not be publicly exposed directly.
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
      example = "vault.example.com";
      description = ''
        FQDN used to access Vaultwarden externally.
        Used for setting the DOMAIN environment variable and ACME certificate configuration.
      '';
    };
  };

  config = mkIf cfg.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ADMIN_TOKEN = "$argon2id$v=19$m=65540,t=3,p=4$7q/+GP5hFwGIp8RG+/XDctDhkM3d+P0yaIBjx2Q6q4g$3eDxkpcfRopvzTtZUPTX387qiYTG1ACbRB6k5Td9ogI";
        DOMAIN = "https://${cfg.vaultwarden.domain}:${toString cfg.reverseProxy.port}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.vaultwarden.port;
        SIGNUPS_ALLOWED = false;
      };
    };

  };

}
