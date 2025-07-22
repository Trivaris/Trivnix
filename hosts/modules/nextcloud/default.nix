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

  options.nixosConfig.nextcloud = import ./config lib;

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
