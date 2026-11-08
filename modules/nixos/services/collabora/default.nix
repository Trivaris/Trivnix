{
  flake.nixosModules.services-collabora =
    { config, lib, ... }:
    let
      collaboraPreferences = config.host.preferences.collabora;
    in
    {
      config = lib.mkIf collaboraPreferences.enable {
        services.collabora-online = {
          inherit (collaboraPreferences.reverseProxy) port;
          enable = true;
          settings =
            let
              rPEnabled = collaboraPreferences.reverseProxy.enable;
            in
            {
              server_name = collaboraPreferences.reverseProxy.domain;

              ssl = {
                enable = !rPEnabled;
                termination = rPEnabled;
              };

              net = {
                listen = "127.0.0.1";
                post_allow.host = [ "127.0.0.1" ];
              };

              storage.wopi = lib.mkIf (collaboraPreferences.nextcloudFQDNs != null) {
                "@allow" = true;
                host = collaboraPreferences.nextcloudFQDNs;
              };
            };
        };
      };
    };
}
