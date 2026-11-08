{
  flake.nixosModules.services-vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      vaultwardenPreferences = config.host.preferences.vaultwarden;
      # mailServerPreferences = config.host.preferences.mailServer;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf vaultwardenPreferences.enable {
        services.vaultwarden = {
          enable = true;
          environmentFile = secrets.vaultwarden-admin-token.path;
          config = {
            DOMAIN = "https://${vaultwardenPreferences.reverseProxy.domain}:${toString vaultwardenPreferences.reverseProxy.port}";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = vaultwardenPreferences.reverseProxy.port;
            SIGNUPS_ALLOWED = false;
          };
          # // (lib.optionalAttrs vaultwardenPreferences.sendMails {
          #   SMTP_SSL = false;
          #   SMTP_HOST = "127.0.0.1";
          #   SMTP_PORT = 25;
          #   SMTP_FROM = "no-reply@vault.${mailServerPreferences.domain}";
          #   SMTP_FROM_NAME = "Vaultwarden";
          # });
        };

        # host.preferences.mailServer = lib.mkIf vaultwardenPreferences.sendMails {
        #   extraDomains = [ "vault" ];
        #   accounts."no-reply@vaultwarden.${mailServerPreferences.domain}".passwordFile =
        #     secrets.mail-vaultwarden-password.path;
        # };
      };
    };
}
