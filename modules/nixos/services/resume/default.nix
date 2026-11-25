{
  flake.nixosModules.services-resume =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      resumePreferences = config.host.preferences.resume;
      docker = lib.getExe pkgs.docker;
      networkName = "resume";

      db = {
        name = "resume";
        user = "resume";
        passwd = "resume";
      };

      s3 = {
        accessKey = "seaweedfs";
        secretKey = "seaweedfs";
        bucket = "reactive-resume";
        endpoint = "http://resume-seaweedfs:8333";
      };

      containerNames = [
        "resume"
        "resume-postgres"
        "resume-redis"
        "resume-seaweedfs"
      ];
      networkUsers = (map (n: "docker-${n}.service") containerNames) ++ [
        "resume-create-bucket.service"
      ];

      # Replaces depends_on: condition: service_healthy
      waitHealthy =
        name:
        pkgs.writeShellScript "wait-${name}-healthy" ''
          for _ in $(seq 1 90); do
            status=$(${docker} inspect -f '{{.State.Health.Status}}' ${name} 2>/dev/null || true)
            [ "$status" = "healthy" ] && exit 0
            sleep 2
          done
          echo "${name} did not become healthy" >&2
          exit 1
        '';

      healthOpts =
        {
          cmd,
          start ? "10s",
        }:
        [
          "--health-cmd=${cmd}"
          "--health-start-period=${start}"
          "--health-interval=30s"
          "--health-timeout=10s"
          "--health-retries=3"
        ];
    in
    {
      options.host.preferences.resume = {
        enable = lib.mkEnableOption "Reactive Resume, a resume builder";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };

      config = lib.mkIf resumePreferences.enable {
        virtualisation.docker.enable = true;
        virtualisation.oci-containers = {
          backend = "docker";
          containers = {
            resume-postgres = {
              image = "postgres:latest";
              environment = {
                POSTGRES_DB = db.name;
                POSTGRES_USER = db.user;
                POSTGRES_PASSWORD = db.passwd;
              };
              volumes = [ "resume-pgdata:/var/lib/postgresql" ];
              extraOptions = [
                "--network=${networkName}"
              ]
              ++ healthOpts { cmd = "pg_isready -U ${db.user} -d ${db.name}"; };
            };

            resume-redis = {
              image = "redis:latest";
              cmd = [
                "redis-server"
                "--appendonly"
                "yes"
              ];
              volumes = [ "resume-redisdata:/data" ];
              extraOptions = [
                "--network=${networkName}"
              ]
              ++ healthOpts {
                cmd = "redis-cli ping";
                start = "5s";
              };
            };

            resume-seaweedfs = {
              image = "chrislusf/seaweedfs:latest";
              cmd = [
                "server"
                "-s3"
                "-filer"
                "-dir=/data"
                "-ip=0.0.0.0"
              ];
              environment = {
                AWS_ACCESS_KEY_ID = s3.accessKey;
                AWS_SECRET_ACCESS_KEY = s3.secretKey;
              };
              volumes = [ "resume-s3data:/data" ];
              extraOptions = [
                "--network=${networkName}"
              ]
              ++ healthOpts { cmd = "wget -q -O /dev/null http://localhost:8888"; };
            };

            resume = {
              image = "ghcr.io/reactive-resume/reactive-resume:latest";
              dependsOn = [
                "resume-postgres"
                "resume-redis"
                "resume-seaweedfs"
              ];
              ports = [
                "${
                  if resumePreferences.reverseProxy.enable then "127.0.0.1" else "0.0.0.0"
                }:${toString resumePreferences.reverseProxy.port}:3000"
              ];
              volumes = [ "resume-appdata:/app/data" ];
              environment = {
                APP_URL = "${
                  if resumePreferences.reverseProxy.enable then "https" else "http"
                }://${resumePreferences.reverseProxy.domain}";
                DATABASE_URL = "postgresql://${db.user}:${db.passwd}@resume-postgres:5432/${db.name}";
                REDIS_URL = "redis://resume-redis:6379";
                STORAGE_BACKEND = "s3";
                S3_ENDPOINT = s3.endpoint;
                S3_ACCESS_KEY_ID = s3.accessKey;
                S3_SECRET_ACCESS_KEY = s3.secretKey;
                S3_BUCKET = s3.bucket;
                S3_REGION = "us-east-1";
                S3_FORCE_PATH_STYLE = "true";
                # FLAG_DISABLE_SIGNUPS = "true"; # enable after creating your account
              };
              environmentFiles = [ config.sops.templates."resume.env".path ];
              extraOptions = [
                "--network=${networkName}"
              ]
              ++ healthOpts {
                cmd = "node -e \"fetch('http://127.0.0.1:3000/api/health').then(r => { if (!r.ok) process.exit(1) }).catch(() => process.exit(1))\"";
              };
            };
          };
        };

        systemd.services.resume-create-bucket = {
          after = [ "docker-resume-seaweedfs.service" ];
          requires = [ "docker-resume-seaweedfs.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStartPre = waitHealthy "resume-seaweedfs";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          script = ''
            ${docker} run --rm --network=${networkName} \
              -e AWS_ACCESS_KEY_ID=${s3.accessKey} \
              -e AWS_SECRET_ACCESS_KEY=${s3.secretKey} \
              -e AWS_DEFAULT_REGION=us-east-1 \
              --entrypoint /bin/sh amazon/aws-cli:latest -c '
                aws --endpoint-url ${s3.endpoint} s3api head-bucket --bucket ${s3.bucket} 2>/dev/null ||
                aws --endpoint-url ${s3.endpoint} s3 mb s3://${s3.bucket}
              '
          '';
        };

        systemd.services.docker-resume = {
          after = [ "resume-create-bucket.service" ];
          requires = [ "resume-create-bucket.service" ];
          serviceConfig.ExecStartPre = map waitHealthy [
            "resume-postgres"
            "resume-redis"
            "resume-seaweedfs"
          ];
        };

        systemd.services."docker-network-${networkName}" = {
          after = [ "docker.service" ];
          requires = [ "docker.service" ];
          before = networkUsers;
          requiredBy = networkUsers;
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            ${docker} network inspect ${networkName} >/dev/null 2>&1 || \
              ${docker} network create ${networkName}
          '';
        };

        sops = {
          secrets.resume-auth-secret = {
            sopsFile = config.host.private.secrets.hostSecretsFile;
            owner = "root";
            group = "root";
            mode = "0400";
          };
          secrets.resume-encryption-secret = {
            sopsFile = config.host.private.secrets.hostSecretsFile;
            owner = "root";
            group = "root";
            mode = "0400";
          };
          templates."resume.env" = {
            content = ''
              AUTH_SECRET=${config.sops.placeholder.resume-auth-secret}
              ENCRYPTION_SECRET=${config.sops.placeholder.resume-encryption-secret}
            '';
            restartUnits = [ "docker-resume.service" ];
          };
        };
      };
    };
}
