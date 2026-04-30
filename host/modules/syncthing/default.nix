{
  config,
  lib,
  ...
}:
let
  syncthingPrefs = config.hostPrefs.syncthing;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf syncthingPrefs.enable {
    services.syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:${toString syncthingPrefs.reverseProxy.port}";
      guiPasswordFile = secrets.syncthing-gui-password.path;
      openDefaultPorts = true;
      settings.gui = {
        user = config.hostPrefs.mainUser;
        authMode = "static";
        sendBasicAuthPrompt = true;
        insecureAdminAccess = false;
      };
    };

    services.nginx.virtualHosts."${syncthingPrefs.reverseProxy.domain}".locations = lib.mkIf syncthingPrefs.reverseProxy.enable(lib.mkForce  {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString syncthingPrefs.reverseProxy.port}/";
        recommendedProxySettings = false;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    });
  };
}