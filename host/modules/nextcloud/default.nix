{
  config,
  lib,
  pkgs,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.nextcloud = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.nextcloud.enable {
    users.users.nextcloud.extraGroups = [ "redis" ];
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;
        hostName = prefs.nextcloud.reverseProxy.domain;
        https = true;
        database.createLocally = true;
        configureRedis = true;

        config = {
          adminuser = "admin";
          adminpassFile = config.sops.secrets.nextcloud-admin-token.path;
          dbtype = "pgsql";
        };
      };

      postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];

        ensureUsers = [
          {
            name = "nextcloud";
            ensureDBOwnership = true;
          }
        ];
      };

      redis.servers.${prefs.nextcloud.reverseProxy.domain} = {
        enable = true;
        unixSocketPerm = 770;
      };
    };
  };
}
