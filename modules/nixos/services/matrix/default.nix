{
  flake.nixosModules.services-matrix =
    {
      config,
      lib,
      ...
    }:
    let
      matrix-prefs = config.host-prefs.matrix;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf matrix-prefs.enable {
        services.matrix-conduit = {
          enable = true;
          secretFile = secrets.matrix-secrets.path;
          settings.global = {
            address = if matrix-prefs.reverseProxy.enable then "0.0.0.0" else matrix-prefs.reverseProxy.domain;
            port = matrix-prefs.reverseProxy.port;
            server_name = matrix-prefs.name;
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
    };
}
