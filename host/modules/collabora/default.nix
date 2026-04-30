{ config, lib, ... }:
let
  collaboraPrefs = config.hostPrefs.collabora;
in
{
  config = lib.mkIf collaboraPrefs.enable {
    services.collabora-online = {
      inherit (collaboraPrefs.reverseProxy) port;
      enable = true;
      settings =
        let
          rPEnabled = collaboraPrefs.reverseProxy.enable;
        in
        {
          server_name = collaboraPrefs.reverseProxy.domain;

          ssl = {
            enable = !rPEnabled;
            termination = rPEnabled;
          };

          net = {
            listen = "127.0.0.1";
            post_allow.host = [ "127.0.0.1" ];
          };

          storage.wopi = lib.mkIf (collaboraPrefs.nextcloudFQDNs != null) {
            "@allow" = true;
            host = collaboraPrefs.nextcloudFQDNs;
          };
        };
    };
  };
}
