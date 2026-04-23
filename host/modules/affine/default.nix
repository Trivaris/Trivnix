{
  config,
  pkgs,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.affine.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers = {
      backend = "docker";
      containers.affine = {
        image = "ghcr.io/toeverything/affine:stable";
        dependsOn = [ "affine-postgres" "affine-redis" ];
        ports = [ "${toString prefs.affine.reverseProxy.port}:${toString prefs.affine.reverseProxy.port}" ];
        environment = {
          AFFINE_REVISION = "stable";
          AFFINE_SERVER_HOST = prefs.affine.reverseProxy.domain;
          AFFINE_SERVER_HTTPS = "true";
          REDIS_SERVER_HOST = "affine-redis";
          PORT = toString prefs.affine.reverseProxy.port;
          DB_DATA_LOCATION = "/var/lib/affine/postgres";
          UPLOAD_LOCATION = "/var/lib/affine/storage";
          CONFIG_LOCATION = "/var/lib/affine/config";
          DB_USERNAME = "affine";
          DB_DATABASE = "affine";
        };
        extraOptions = [ "--network=affine-network" ];
        environmentFiles = [ config.sops.secrets.affine-db-password-env.path ];
      };

      containers.affine-migration = {
        image = "ghcr.io/toeverything/affine:stable";
        inherit (config.virtualisation.oci-containers.containers.affine) environment environmentFiles extraOptions;
      };
    
      containers.affine-postgres = {
        image = "pgvector/pgvector:pg16";
        volumes = [ "/var/lib/affine/postgres:/var/lib/postgresql/data" ];
        environment = {
          POSTGRES_USER = "affine";
          POSTGRES_DB = "affine";
        };
        extraOptions = [ "--network=affine-network" ];
        environmentFiles = [ config.sops.secrets.affine-postgres-password-env.path ];
      };

      containers.affine-redis = {
        image = "redis:7";
        extraOptions = [ "--network=affine-network" ];
      };
    };

    users.groups.affine = {};
    users.users.affine = {
      isSystemUser = true;
      group = "affine";
    };

    systemd.services = {
      docker-affine = {
        after = [ "create-affine-network.service" ];
        requires = [ "create-affine-network.service" ];
      };

      docker-affine-postgres.after = [ "create-affine-network.service" ];
      docker-affine-redis.after = [ "create-affine-network.service" ];
      create-affine-network = {
        description = "Create the Docker network for affine";
        after = [ "network.target" "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.docker}/bin/docker network create affine-network";
          ExecStop = "${pkgs.docker}/bin/docker network rm affine-network";
          ExecStartPre = "-${pkgs.docker}/bin/docker network rm affine-network"; 
        };
      };
    };

    hostPrefs.mailserver = lib.mkIf prefs.affine.sendMails {
      extraDomains = [ "affine" ];
      accounts."no-reply@affine.${prefs.mailserver.domain}".passwordFile = config.sops.secrets.mail-affine-password.path;
    };
  };
}