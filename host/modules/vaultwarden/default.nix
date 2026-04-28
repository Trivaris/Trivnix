{
  config,
  lib,
  ...
}:
let
  vaultwardenPrefs = config.hostPrefs.vaultwarden;
  mailserverPrefs = config.hostPrefs.mailserver;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf vaultwardenPrefs.enable {
    services.vaultwarden = {
      enable = true;
      environmentFile = secrets.vaultwarden-admin-token.path;
      config = {
        DOMAIN = "https://${vaultwardenPrefs.reverseProxy.domain}:${toString vaultwardenPrefs.reverseProxy.port}";
        ROCKET_ADDRESS = vaultwardenPrefs.reverseProxy.ipAddress;
        ROCKET_PORT = vaultwardenPrefs.reverseProxy.port;
        SIGNUPS_ALLOWED = false;
      }
      // (lib.optionalAttrs vaultwardenPrefs.sendMails {
        SMTP_SSL = false;
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_FROM = "no-reply@vault.${mailserverPrefs.domain}";
        SMTP_FROM_NAME = "Vaultwarden";
      });
    };

    hostPrefs.mailserver = lib.mkIf vaultwardenPrefs.sendMails {
      extraDomains =  [ "vault" ];
      accounts."no-reply@vaultwarden.${mailserverPrefs.domain}".passwordFile = secrets.mail-vaultwarden-password.path;
    };
  };
}
