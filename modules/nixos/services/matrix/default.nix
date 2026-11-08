{
  flake.nixosModules.services-matrix =
    {
      config,
      lib,
      ...
    }:
    let
      matrixPreferences = config.host.preferences.matrix;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf matrixPreferences.enable {
        services.matrix-conduit = {
          enable = true;
          secretFile = secrets.matrix-secrets.path;
          settings.global = {
            address =
              if matrixPreferences.reverseProxy.enable then "0.0.0.0" else matrixPreferences.reverseProxy.domain;
            port = matrixPreferences.reverseProxy.port;
            server_name = matrixPreferences.name;
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
