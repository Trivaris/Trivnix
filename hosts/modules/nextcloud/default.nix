{
  pkgs,
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.nextcloud = import ./config.nix { inherit (lib) mkEnableOption; inherit (trivnixLib) mkReverseProxyOption; };

  config = mkIf (prefs.nextcloud.enable) {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = prefs.nextcloud.reverseProxy.domain;
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
      servers.${prefs.nextcloud.reverseProxy.domain} = {
        enable = true;
        unixSocketPerm = 770;
      };
    };

    users.users.nextcloud.extraGroups = [ "redis" ];
  };
}
