{ inputs, ... }:
{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.services-mailserver =
    {
      config,
      lib,
      ...
    }:
    let
      mailServerPreferences = config.host.preferences.mailServer;
      reverseProxyPreferences = config.host.preferences.reverseProxy;
    in
    {
      imports = [
        inputs.mailserver.nixosModules.default
        (lib.mkAliasOptionModule [ "host.preferences" "mailserver" "accounts" ] [ "mailserver" "accounts" ])
      ];

      config = lib.mkIf mailServerPreferences.enable {
        mailserver = {
          enable = true;
          fqdn = mailServerPreferences.domain;
          x509.useACMEHost = mailServerPreferences.domain;
          domains = [
            mailServerPreferences.domain
          ]
          ++ map (domain: "${domain}.${mailServerPreferences.domain}") mailServerPreferences.extraDomains;
          dkim = {
            enable = true;

            defaults = {
              keyType = "rsa";
              keyLength = 2048;
            };

            domains = {
              "${mailServerPreferences.domain}".selectors.rsa-2026-04 = { };
            }
            // lib.listToAttrs (
              map (
                domain:
                lib.nameValuePair "${domain}.${mailServerPreferences.domain}" { selectors.rsa-2026-04 = { }; }
              ) mailServerPreferences.extraDomains
            );
          };

          stateVersion = lib.pipe config.host.info.stateVersion [
            (lib.splitString ".")
            lib.head
            lib.toInt
          ];
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = reverseProxyPreferences.email;
          certs.${mailServerPreferences.domain} = {
            dnsProvider = "cloudflare";
            extraDomainNames = map (name: "${name}.${mailServerPreferences.domain}") (
              [
                "imap"
                "smtp"
                "autoconfig"
                "autodiscover"
              ]
              ++ mailServerPreferences.extraDomains
            );
          };
        };

        services = {
          automx2 = {
            enable = true;
            domain = mailServerPreferences.domain;
            settings = {
              provider = mailServerPreferences.providerName;
              domains = [ mailServerPreferences.domain ];

              servers = [
                {
                  type = "imap";
                  name = "imap.${mailServerPreferences.domain}";
                  port = mailServerPreferences.imapPort;
                }
                {
                  type = "smtp";
                  name = "smtp.${mailServerPreferences.domain}";
                  port = mailServerPreferences.smtpPort;
                }
              ];
            };
          };

          nginx.virtualHosts."autoconfig.${mailServerPreferences.domain}" = {
            forceSSL = true;
            enableACME = lib.mkForce false;
            useACMEHost = lib.mkForce mailServerPreferences.domain;
            locations."/".proxyPass = lib.mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
          };
        };
      };
    };
}
