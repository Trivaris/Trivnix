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
            listen = collaboraPrefs.reverseProxy.ipAddress;
            post_allow.host = [ collaboraPrefs.reverseProxy.ipAddress ];
          };

          storage.wopi = lib.mkIf (collaboraPrefs.nextcloudFQDNs != null) {
            "@allow" = true;
            host = collaboraPrefs.nextcloudFQDNs;
          };
        };
    };
  };
}
