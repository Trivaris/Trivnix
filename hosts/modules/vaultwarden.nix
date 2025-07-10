{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.vaultwarden = mkEnableOption "vaultwarden";

  config = mkIf cfg.vaultwarden {

    services.vaultwarden = {
      dbBackend = "sqlite";
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 25565;
        DOMAIN = "https://host.joneit.de";
        SIGNUPS_ALLOWED = true;
        ADMIN_TOKEN = "$argon2id$v=19$m=65540,t=3,p=4$...";
        LOG_FILE = "/var/lib/bitwarden_rs/access.log";
      };
    };

    security.acme.defaults.email = "nginx@tripple.lurdane.de";
    security.acme.acceptTerms = true;

    # The nginx reverse proxy
    services.nginx = let vault-host = "host.joneit.de"; in {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."${vault-host}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          access_log /var/log/nginx/${vault-host}.access.log;
          error_log /var/log/nginx/${vault-host}.error.log;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

  };

}
