{
  flake.nixosModules.services-forgejo =
    {
      config,
      lib,
      ...
    }:
    let
      forgejoPreferences = config.host.preferences.forgejo;
      # mailServerPreferences = config.host.preferences.mailServer;
      # secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf forgejoPreferences.enable {
        services.forgejo = {
          enable = true;
          lfs.enable = true;
          database.type = "postgres";

          settings = {
            session.COOKIE_SECURE = true;
            service.DISABLE_REGISTRATION = true;

            actions = {
              ENABLED = true;
              DEFAULT_ACTIONS_URL = "github";
            };

            server = {
              DOMAIN = forgejoPreferences.reverseProxy.domain;
              ROOT_URL = "https://${forgejoPreferences.reverseProxy.domain}/";
              HTTP_ADDR = "127.0.0.1";
              HTTP_PORT = forgejoPreferences.reverseProxy.port;
            };

            # mailer = lib.optionalAttrs forgejoPreferences.sendMails {
            #   ENABLED = true;
            #   PROTOCOL = "smtp";
            #   SMTP_ADDR = "127.0.0.1";
            #   SMTP_PORT = 25;
            #   FROM = "no-reply@forgejo.${mailServerPreferences.domain}";
            # };
          };
        };

        # host.preferences.mailServer = {
        #   extraDomains = lib.mkIf forgejoPreferences.sendMails [ "forgejo" ];
        #   accounts."no-reply@forgejo.${mailServerPreferences.domain}".passwordFile =
        #     secrets.mail-forgejo-password.path;
        # };
      };
    };
}
