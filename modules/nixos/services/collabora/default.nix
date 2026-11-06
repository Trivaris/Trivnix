{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.services-collabora =
    { config, lib, ... }:
    let
      collabora-prefs = config.host-prefs.collabora;
    in
    {
      config = lib.mkIf collabora-prefs.enable {
        services.collabora-online = {
          inherit (collabora-prefs.reverseProxy) port;
          enable = true;
          settings =
            let
              rPEnabled = collabora-prefs.reverseProxy.enable;
            in
            {
              server_name = collabora-prefs.reverseProxy.domain;

              ssl = {
                enable = !rPEnabled;
                termination = rPEnabled;
              };

              net = {
                listen = "127.0.0.1";
                post_allow.host = [ "127.0.0.1" ];
              };

              storage.wopi = lib.mkIf (collabora-prefs.nextcloudFQDNs != null) {
                "@allow" = true;
                host = collabora-prefs.nextcloudFQDNs;
              };
            };
        };
      };
    };
}
