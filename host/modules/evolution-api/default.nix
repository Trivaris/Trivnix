{
  config,
  lib,
  pkgs,
  ...
}:
let
  evolutionPrefs = config.hostPrefs.evolution;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf evolutionPrefs.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers = {
      backend = "docker";
      containers.evolution-api = {
        image = "atendai/evolution-api:latest";
        ports = [ "${toString evolutionPrefs.reverseProxy.port}:${toString evolutionPrefs.reverseProxy.port}" ];
        environmentFiles = [ secrets.evolution-api-env.path ];
        extraOptions = [ "--network=evolution-api-network" ];
        volumes = [
          "evolution_store:/evolution/store"
          "evolution_instances:/evolution/instances"
        ];
        environment = {
          SERVER_URL = "https://${evolutionPrefs.reverseProxy.domain}";
          SERVER_PORT = toString evolutionPrefs.reverseProxy.port;
          SERVER_TYPE = "http";
          
          AUTHENTICATION_TYPE = "apikey";
          
          DATABASE_ENABLED = "true";
          DATABASE_PROVIDER = "postgresql";
          
          LOG_LEVEL = "ERROR,WARN,INFO";
          DEL_INSTANCE = "false";
          
          CACHE_REDIS_ENABLED = "true";
          CACHE_REDIS_HOST = "evolution-api-redis";
          CACHE_REDIS_PORT = "6379";
          
          REDIS_ENABLED = "true";
          CACHE_REDIS_URI = "redis://evolution-api-redis:6379/6";
          CACHE_REDIS_TTL = "604800";
          CACHE_REDIS_PREFIX_KEY = "evolution";
          CACHE_REDIS_SAVE_INSTANCES = "false";
          CACHE_LOCAL_ENABLED = "false";

          CHATWOOT_ENABLED = "false";
          TYPEBOT_ENABLED = "false";
          USER_FACADE = "true";
        };
      };
      
      containers.evolution-api-postgres = {
        image = "pgvector/pgvector:pg16";
        volumes = [ "/var/lib/evolution-api/postgres:/var/lib/postgresql/data" ];
        extraOptions = [ "--network=evolution-api-network" ];
        environmentFiles = [ secrets.evolution-api-postgres-env.path ];
        environment = {
          POSTGRES_USER = "evolution-api";
          POSTGRES_DB = "evolution-api";
        };
      };

      containers.evolution-api-redis = {
        image = "redis:7";
        extraOptions = [ "--network=evolution-api-network" ];
      };
    };

    users.groups.evolution-api = { };
    users.users.evolution-api = {
      isSystemUser = true;
      group = "evolution-api";
    };

    systemd.services = {
      docker-evolution-api = {
        after = [
          "create-evolution-api-network.service"
          "docker-evolution-api-postgres.service" 
          "docker-evolution-api-redis.service"  
        ];
        requires = [ "create-evolution-api-network.service" ];
      };

      docker-evolution-api-postgres.after = [ "create-evolution-api-network.service" ];
      docker-evolution-api-redis.after = [ "create-evolution-api-network.service" ];

      create-evolution-api-network = {
        description = "Create the Docker network for evolution API";
        after = [ "network.target" "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe pkgs.docker} network create evolution-api-network";
          ExecStop = "${lib.getExe pkgs.docker} network rm evolution-api-network";
          ExecStartPre = "-${lib.getExe pkgs.docker} network rm evolution-api-network"; 
        };
      };
    };
  };
}