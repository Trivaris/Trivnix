{
  flake.nixosModules.services-vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      vaultwarden-prefs = config.host-prefs.vaultwarden;
      # mailserver-prefs = config.host-prefs.mailserver;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf vaultwarden-prefs.enable {
        services.vaultwarden = {
          enable = true;
          environmentFile = secrets.vaultwarden-admin-token.path;
          config = {
            DOMAIN = "https://${vaultwarden-prefs.reverseProxy.domain}:${toString vaultwarden-prefs.reverseProxy.port}";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = vaultwarden-prefs.reverseProxy.port;
            SIGNUPS_ALLOWED = false;
          };
          # // (lib.optionalAttrs vaultwarden-prefs.sendMails {
          #   SMTP_SSL = false;
          #   SMTP_HOST = "127.0.0.1";
          #   SMTP_PORT = 25;
          #   SMTP_FROM = "no-reply@vault.${mailserver-prefs.domain}";
          #   SMTP_FROM_NAME = "Vaultwarden";
          # });
        };

        # host-prefs.mailserver = lib.mkIf vaultwarden-prefs.sendMails {
        #   extraDomains = [ "vault" ];
        #   accounts."no-reply@vaultwarden.${mailserver-prefs.domain}".passwordFile =
        #     secrets.mail-vaultwarden-password.path;
        # };
      };
    };
}
