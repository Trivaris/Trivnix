{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.nextcloud = {
    enable = mkEnableOption "Enable the Nextcloud service.";
    
    port = mkOption {
      type = types.int;
      default = 8889;
      description = ''
        Local port Nextcloud will bind to.
        Typically used behind a reverse proxy and not exposed directly.
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
      description = ''
        FQDN to access the Nextcloud instance.
        Used in web configuration and TLS certificate issuance.
      '';
      example = "cloud.example.com";
    };
  };

  config = mkIf cfg.nextcloud.enable {
    services.nextcloud = {
      enable = true;
      hostName = cfg.nextcloud.domain;
      https = true;

      config = {
        adminuser = "admin";
        adminpassFile = config.sops.secrets.nextcloud-admin-token.path;
        dbtype = "pgsql";
      };

      database.createLocally = true;
      configureRedis = true;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];

      ensureUsers = [{
        name = "nextcloud";
        ensureDBOwnership = true;
      }];
    };

    services.redis = {
      servers."${cfg.nextcloud.domain}" = {
        enable = true;
        unixSocketPerm = 770;
      };
    };

    users.users.nextcloud.extraGroups = [ "redis" ];
  };

}
