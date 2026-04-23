{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "hostPrefs" "mailserver" "accounts" ]
      [ "mailserver" "accounts" ]
    )
  ];

  config = lib.mkIf prefs.mailserver.enable {
    mailserver = {
      enable = true;
      fqdn = prefs.mailserver.domain;
      x509.useACMEHost = prefs.mailserver.domain;
      domains = [ prefs.mailserver.domain ] ++ map (domain: "${domain}.${prefs.mailserver.domain}") prefs.mailserver.extraDomains;
      dkim = {
        enable = true;
        
        defaults = {
          keyType = "rsa";
          keyLength = 2048;
        };

        domains = {
          "${prefs.mailserver.domain}".selectors.rsa-2026-04 = { };
        } // lib.listToAttrs (map (domain: lib.nameValuePair "${domain}.${prefs.mailserver.domain}" { selectors.rsa-2026-04 = { }; }) prefs.mailserver.extraDomains);
      };

      stateVersion = lib.pipe config.hostInfos.stateVersion [
        (lib.splitString ".")
        lib.head
        lib.toInt
      ];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = prefs.reverseProxy.email;
      certs.${prefs.mailserver.domain} = {
        dnsProvider = "cloudflare";
        extraDomainNames = map (name: "${name}.${prefs.mailserver.domain}") ([
          "imap"
          "smtp"
          "autoconfig"
          "autodiscover"
        ] ++ prefs.mailserver.extraDomains);
      };
    };

    services = {
      automx2 = {
        enable = true;
        domain = prefs.mailserver.domain;
        settings = {
          provider = prefs.mailserver.providerName;
          domains = [ prefs.mailserver.domain ];

          servers = [
            {
              type = "imap";
              name = "imap.${prefs.mailserver.domain}";
              port = prefs.mailserver.imapPort;
            }
            {
              type = "smtp";
              name = "smtp.${prefs.mailserver.domain}";
              port = prefs.mailserver.smtpPort;
            }
          ];
        };
      };

      nginx.virtualHosts."autoconfig.${prefs.mailserver.domain}" = {
        forceSSL = true;
        enableACME = lib.mkForce false;
        useACMEHost = lib.mkForce prefs.mailserver.domain;
        locations."/".proxyPass = lib.mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
      };
    };
  };
}
