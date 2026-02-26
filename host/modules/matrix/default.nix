{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.matrix.enable {
    services.matrix-conduit = {
      enable = true;
      secretFile = config.sops.secrets.matrix-secrets.path;
      settings.global = {
        address = if prefs.matrix.reverseProxy.enable then "0.0.0.0" else prefs.matrix.reverseProxy.domain;
        port = prefs.matrix.reverseProxy.port;
        server_name = prefs.matrix.name;
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