{
  flake.nixosModules.services-n8n =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      n8n-prefs = config.host-prefs.n8n;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf n8n-prefs.enable {
        services.n8n = {
          enable = true;
          openFirewall = !n8n-prefs.reverseProxy.enable;
          environment = {
            N8N_PORT = toString n8n-prefs.reverseProxy.port;
            WEBHOOK_URL = "https://${n8n-prefs.reverseProxy.domain}";
            N8N_RUNNERS_ENABLED = "true";
            N8N_RUNNERS_MODE = "external";
            N8N_RUNNERS_AUTH_TOKEN_FILE = secrets.n8n-runner-auth-token.path;
          };
          taskRunners = {
            enable = true;
            environment.N8N_RUNNERS_AUTH_TOKEN_FILE = secrets.n8n-runner-auth-token.path;
            runners.python = {
              command = lib.getExe pkgs.python315;
              healthCheckPort = n8n-prefs.reverseProxy.port - 1;
            };
          };
        };

        systemd.services.n8n.path = [
          pkgs.nodejs
          pkgs.gnutar
          pkgs.gzip
        ];
      };
    };
}
