{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.collabora.enable {
    services.collabora-online = {
      inherit (prefs.collabora.reverseProxy) port;
      enable = true;
      settings =
        let
          rPEnabled = prefs.collabora.reverseProxy.enable;
        in
        {
          server_name = prefs.collabora.reverseProxy.domain;

          ssl = {
            enable = !rPEnabled;
            termination = rPEnabled;
          };

          net = {
            listen = prefs.collabora.reverseProxy.ipAddress;
            post_allow.host = [ prefs.collabora.reverseProxy.ipAddress ];
          };

          storage.wopi = lib.mkIf (prefs.collabora.nextcloudFQDNs != null) {
            "@allow" = true;
            host = prefs.collabora.nextcloudFQDNs;
          };
        };
    };
  };
}
