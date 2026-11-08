{
  flake.nixosModules.services-n8n =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      n8nPreferences = config.host.preferences.n8n;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf n8nPreferences.enable {
        services.n8n = {
          enable = true;
          openFirewall = !n8nPreferences.reverseProxy.enable;
          environment = {
            N8N_PORT = toString n8nPreferences.reverseProxy.port;
            WEBHOOK_URL = "https://${n8nPreferences.reverseProxy.domain}";
            N8N_RUNNERS_ENABLED = "true";
            N8N_RUNNERS_MODE = "external";
            N8N_RUNNERS_AUTH_TOKEN_FILE = secrets.n8n-runner-auth-token.path;
          };
          taskRunners = {
            enable = true;
            environment.N8N_RUNNERS_AUTH_TOKEN_FILE = secrets.n8n-runner-auth-token.path;
            runners.python = {
              command = lib.getExe pkgs.python315;
              healthCheckPort = n8nPreferences.reverseProxy.port - 1;
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
