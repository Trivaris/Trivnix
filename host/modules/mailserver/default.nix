{
  config,
  lib,
  ...
}:
let
  mailserverPrefs = config.hostPrefs.mailserver;
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "hostPrefs" "mailserver" "accounts" ]
      [ "mailserver" "accounts" ]
    )
  ];

  config = lib.mkIf mailserverPrefs.enable {
    mailserver = {
      enable = true;
      fqdn = mailserverPrefs.domain;
      x509.useACMEHost = mailserverPrefs.domain;
      domains = [ mailserverPrefs.domain ] ++ map (domain: "${domain}.${mailserverPrefs.domain}") mailserverPrefs.extraDomains;
      dkim = {
        enable = true;
        
        defaults = {
          keyType = "rsa";
          keyLength = 2048;
        };

        domains = {
          "${mailserverPrefs.domain}".selectors.rsa-2026-04 = { };
        } // lib.listToAttrs (map (domain: lib.nameValuePair "${domain}.${mailserverPrefs.domain}" { selectors.rsa-2026-04 = { }; }) mailserverPrefs.extraDomains);
      };

      stateVersion = lib.pipe config.hostInfos.stateVersion [
        (lib.splitString ".")
        lib.head
        lib.toInt
      ];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = reverseProxyPrefs.email;
      certs.${mailserverPrefs.domain} = {
        dnsProvider = "cloudflare";
        extraDomainNames = map (name: "${name}.${mailserverPrefs.domain}") ([
          "imap"
          "smtp"
          "autoconfig"
          "autodiscover"
        ] ++ mailserverPrefs.extraDomains);
      };
    };

    services = {
      automx2 = {
        enable = true;
        domain = mailserverPrefs.domain;
        settings = {
          provider = mailserverPrefs.providerName;
          domains = [ mailserverPrefs.domain ];

          servers = [
            {
              type = "imap";
              name = "imap.${mailserverPrefs.domain}";
              port = mailserverPrefs.imapPort;
            }
            {
              type = "smtp";
              name = "smtp.${mailserverPrefs.domain}";
              port = mailserverPrefs.smtpPort;
            }
          ];
        };
      };

      nginx.virtualHosts."autoconfig.${mailserverPrefs.domain}" = {
        forceSSL = true;
        enableACME = lib.mkForce false;
        useACMEHost = lib.mkForce mailserverPrefs.domain;
        locations."/".proxyPass = lib.mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
      };
    };
  };
}
