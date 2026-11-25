{
  flake.nixosModules.services-snapotter = { pkgs, lib, config, ... }:
  let 
    snapOtterPreferences = config.host.preferences.snapotter;
    networkName = "snapotter";
    db = {
      name = "snapotter";
      user = "snapotter";
      group = "snapotter";
      passwd = "snapotter";
    };
  in {
    options.host.preferences.snapotter = {
      enable = lib.mkEnableOption "SnapOtter, a digital toolbox";
      reverseProxy = lib.trivnix.mkReverseProxyOption;
    };

    config = lib.mkIf snapOtterPreferences.enable {
      virtualisation.docker.enable = true;
      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          snapotter = {
            image = "snapotter/snapotter:latest";
            ports = [
              "${toString snapOtterPreferences.reverseProxy.port}:${toString snapOtterPreferences.reverseProxy.port}"
            ];
            environment = {
              DATABASE_URL = "postgres://${db.user}:${db.group}@snapotter-postgres:5432/${db.name}";
              DATABASE_MIGRATION_URL = "postgres://${db.user}:${db.group}@snapotter-postgres:5432/${db.name}";
              REDIS_URL = "redis://snapotter-redis:6379";
            };
            volumes = [ "snapotter-data:/data" ];
            dependsOn = [ "snapotter-postgres" "snapotter-redis" ];
            extraOptions = [ "--network=${networkName}" ];
          };

          snapotter-postgres = {
            image = "postgres:17-alpine";
            environment = {
              POSTGRES_USER = db.user;
              POSTGRES_PASSWORD = db.passwd;
              POSTGRES_DB = db.name;
            };
            volumes = ["snapotter-pgdata:/var/lib/postgresql/data"];
            extraOptions = [ "--network=${networkName}" ];
          };

          snapotter-redis = {
            image = "redis:8-alpine";
            volumes = ["snapotter-redisdata:/data"];
            extraOptions = [ "--network=${networkName}" ];
          };
        };
      };

      users.groups.snapotter = { };
      users.users.snapotter = {
        isSystemUser = true;
        group = "snapotter";
      };

      systemd.services."docker-network-${networkName}" = {
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        before = [
          "docker-snapotter.service"
          "docker-snapotter-postgres.service"
          "docker-snapotter-redis.service"
        ];
        requiredBy = [
          "docker-snapotter.service"
          "docker-snapotter-postgres.service"
          "docker-snapotter-redis.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${lib.getExe pkgs.docker} network inspect snapotter >/dev/null 2>&1 || \
            ${lib.getExe pkgs.docker} network create snapotter
        '';
      };
    };
  };
}