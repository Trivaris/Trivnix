{
  flake.nixosModules.networking-headscale = { config, lib, ...}:
  let 
    hpPreferences = config.host.preferences.headplane;
    hsPreferences = config.host.preferences.headscale;
    oicdPreferences = config.host.preferences.oicd;
  in
  {
    config = lib.mkIf hpPreferences.enable {
      services.nginx.virtualHosts."${hpPreferences.reverseProxy.domain}".locations."= /".return = "302 /admin/";
      services.headplane = {
        enable = true;
        settings = {
          integration.agent.enabled = true;
          server = {
            base_url = "https://${hpPreferences.reverseProxy.domain}";
            host = if hpPreferences.reverseProxy.enable then "127.0.0.1" else "0.0.0.0";
            port = hpPreferences.reverseProxy.port;
            cookie_secret_path = config.sops.secrets.headplane-cookie.path;
          };
          oidc = lib.mkIf (oicdPreferences.enable && oicdPreferences.clientId != null) {
            issuer = "https://${oicdPreferences.reverseProxy.domain}";
            client_id = oicdPreferences.clientId;
            client_secret_path = config.sops.secrets.headplane-oidc-secret.path;
            use_pkce = true;
            disable_api_key_login = true;
          };
          headscale = {
            public_url = config.services.headscale.settings.server_url;
            config_path = config.services.headscale.configFile;
            api_key_path = config.sops.secrets.headscale-api-key.path;
            url =
              if hsPreferences.reverseProxy.enable then
                "http://127.0.0.1:${toString config.services.headscale.port}"
              else
                config.services.headscale.settings.server_url;
          };
        };
      };
    };
  };
}
