{
  imports = [
    ./options.nix
    ./secrets.nix
  ];

  flake.nixosModules.services-forgejo =
    {
      config,
      lib,
      ...
    }:
    let
      forgejo-prefs = config.host-prefs.forgejo;
      # mailserver-prefs = config.host-prefs.mailserver;
      # secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf forgejo-prefs.enable {
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
              DOMAIN = forgejo-prefs.reverseProxy.domain;
              ROOT_URL = "https://${forgejo-prefs.reverseProxy.domain}/";
              HTTP_ADDR = "127.0.0.1";
              HTTP_PORT = forgejo-prefs.reverseProxy.port;
            };

            # mailer = lib.optionalAttrs forgejo-prefs.sendMails {
            #   ENABLED = true;
            #   PROTOCOL = "smtp";
            #   SMTP_ADDR = "127.0.0.1";
            #   SMTP_PORT = 25;
            #   FROM = "no-reply@forgejo.${mailserver-prefs.domain}";
            # };
          };
        };

        # host-prefs.mailserver = {
        #   extraDomains = lib.mkIf forgejo-prefs.sendMails [ "forgejo" ];
        #   accounts."no-reply@forgejo.${mailserver-prefs.domain}".passwordFile =
        #     secrets.mail-forgejo-password.path;
        # };
      };
    };
}
