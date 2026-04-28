{
  config,
  lib,
  ...
}:
let
  matrixPrefs = config.hostPrefs.matrix;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf matrixPrefs.enable {
    services.matrix-conduit = {
      enable = true;
      secretFile = secrets.matrix-secrets.path;
      settings.global = {
        address = if matrixPrefs.reverseProxy.enable then "0.0.0.0" else matrixPrefs.reverseProxy.domain;
        port = matrixPrefs.reverseProxy.port;
        server_name = matrixPrefs.name;
        allow_registration = true;
        database_backend = "rocksdb";
        extraConfig = ''
          client_max_body_size 100M; 
          proxy_connect_timeout 600;
          proxy_send_timeout 600;
          proxy_read_timeout 600;
          send_timeout 600;
        '';
      };
    };
  };
}