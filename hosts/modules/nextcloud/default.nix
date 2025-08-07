{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.nextcloud = import ./config.nix {
    inherit (lib) mkEnableOption mkOption types;
  };

  config = mkIf (cfg.nextcloud.enable) {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
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

      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis = {
      servers.${cfg.nextcloud.domain} = {
        enable = true;
        unixSocketPerm = 770;
      };
    };

    users.users.nextcloud.extraGroups = [ "redis" ];
  };
}
