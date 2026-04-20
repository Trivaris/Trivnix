{
  config,
  pkgs,
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
        ports = [ "${prefs.affine.reverseProxy.port}:${prefs.affine.reverseProxy.port}" ];
        environment = {
          AFFINE_REVISION = "stable";
          AFFINE_SERVER_HOST = "${prefs.affine.reverseProxy.domain}";
          AFFINE_SERVER_HTTPS = "true";
          PORT = affinePort = prefs.affine.reverseProxy.port;
          DB_DATA_LOCATION = "/var/lib/affine/postgres";
          UPLOAD_LOCATION = "/var/lib/affine/storage";
          CONFIG_LOCATION = "/var/lib/affine/config";
          DB_USERNAME = "affine";
          DB_DATABASE = "affine";
          DB_PASSWORD = builtins.readFile config.sops.secrets.affine-db-password.path;
        };
      };
    };

    users.groups.affine = {};
    users.users.affine = {
      isSystemUser = true;
      group = "affine";
    };
  };
}