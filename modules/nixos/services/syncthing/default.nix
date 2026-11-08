{
  flake.nixosModules.services-syncthing =
    {
      config,
      lib,
      ...
    }:
    let
      syncthingPreferences = config.host.preferences.syncthing;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf syncthingPreferences.enable {
        services.syncthing = {
          enable = true;
          guiAddress = "127.0.0.1:${toString syncthingPreferences.reverseProxy.port}";
          guiPasswordFile = secrets.syncthing-gui-password.path;
          openDefaultPorts = true;
          overrideDevices = false;
          overrideFolders = false;
          settings.gui = {
            user = config.home.username;
            authMode = "static";
            sendBasicAuthPrompt = true;
            insecureAdminAccess = false;
          };
        };

        services.nginx.virtualHosts."${syncthingPreferences.reverseProxy.domain}".locations =
          lib.mkIf syncthingPreferences.reverseProxy.enable
            (
              lib.mkForce {
                "/" = {
                  proxyPass = "http://127.0.0.1:${toString syncthingPreferences.reverseProxy.port}/";
                  recommendedProxySettings = false;
                  extraConfig = ''
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header X-Forwarded-Proto $scheme;
                    proxy_read_timeout 600s;
                    proxy_send_timeout 600s;
                  '';
                };
              }
            );
      };
    };
}
