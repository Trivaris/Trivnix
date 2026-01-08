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
      [ "hostPrefs" "mailserver" "loginAccounts" ]
      [ "mailserver" "loginAccounts" ]
    )
  ];

  config = lib.mkIf prefs.mailserver.enable {
    mailserver = {
      enable = true;
      fqdn = prefs.mailserver.baseDomain;
      dkimSelector = "dkim";
      dkimKeyType = "ed25519";
      x509.useACMEHost = prefs.mailserver.baseDomain;

      domains = [
        prefs.mailserver.baseDomain
        prefs.mailserver.domain
      ];

      stateVersion = lib.pipe config.hostInfos.stateVersion [
        (lib.splitString ".")
        lib.head
        lib.toInt
      ];
    };

    networking = lib.mkIf prefs.mailserver.enableIpV6 {
      interfaces.${prefs.mailserver.ipV6Interface} = {
        ipv6.addresses = [
          {
            address = prefs.mailserver.ipV6Address;
            prefixLength = 64;
          }
        ];
      };

      defaultGateway6 = {
        address = "fe80::1";
        interface = prefs.mailserver.ipV6Interface;
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = prefs.reverseProxy.email;
      certs.${prefs.mailserver.baseDomain} = {
        dnsProvider = "cloudflare";
        extraDomainNames = map (name: "${name}.${prefs.mailserver.baseDomain}") [
          "imap"
          "smtp"
          "autoconfig"
          "autodiscover"
          "mail"
        ];
      };

    };

    services = {
      automx2 = {
        enable = true;
        domain = prefs.mailserver.baseDomain;
        settings = {
          provider = prefs.mailserver.providerName;
          domains = [ prefs.mailserver.baseDomain ];

          servers = [
            {
              type = "imap";
              name = "imap.${prefs.mailserver.baseDomain}";
              port = prefs.mailserver.imapPort;
            }
            {
              type = "smtp";
              name = "smtp.${prefs.mailserver.baseDomain}";
              port = prefs.mailserver.smtpPort;
            }
          ];
        };
      };

      nginx.virtualHosts."autoconfig.${prefs.mailserver.baseDomain}" = {
        forceSSL = true;
        enableACME = lib.mkForce false;
        useACMEHost = lib.mkForce prefs.mailserver.baseDomain;
        locations."/".proxyPass = lib.mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
      };
    };
  };
}
