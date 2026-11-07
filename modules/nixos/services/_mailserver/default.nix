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
      mailserver-prefs = config.host-prefs.mailserver;
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
    in
    {
      imports = [
        inputs.mailserver.nixosModules.default
        (lib.mkAliasOptionModule [ "host-prefs" "mailserver" "accounts" ] [ "mailserver" "accounts" ])
      ];

      config = lib.mkIf mailserver-prefs.enable {
        mailserver = {
          enable = true;
          fqdn = mailserver-prefs.domain;
          x509.useACMEHost = mailserver-prefs.domain;
          domains = [
            mailserver-prefs.domain
          ]
          ++ map (domain: "${domain}.${mailserver-prefs.domain}") mailserver-prefs.extraDomains;
          dkim = {
            enable = true;

            defaults = {
              keyType = "rsa";
              keyLength = 2048;
            };

            domains = {
              "${mailserver-prefs.domain}".selectors.rsa-2026-04 = { };
            }
            // lib.listToAttrs (
              map (
                domain: lib.nameValuePair "${domain}.${mailserver-prefs.domain}" { selectors.rsa-2026-04 = { }; }
              ) mailserver-prefs.extraDomains
            );
          };

          stateVersion = lib.pipe config.host-infos.stateVersion [
            (lib.splitString ".")
            lib.head
            lib.toInt
          ];
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = reverse-proxy-prefs.email;
          certs.${mailserver-prefs.domain} = {
            dnsProvider = "cloudflare";
            extraDomainNames = map (name: "${name}.${mailserver-prefs.domain}") (
              [
                "imap"
                "smtp"
                "autoconfig"
                "autodiscover"
              ]
              ++ mailserver-prefs.extraDomains
            );
          };
        };

        services = {
          automx2 = {
            enable = true;
            domain = mailserver-prefs.domain;
            settings = {
              provider = mailserver-prefs.providerName;
              domains = [ mailserver-prefs.domain ];

              servers = [
                {
                  type = "imap";
                  name = "imap.${mailserver-prefs.domain}";
                  port = mailserver-prefs.imapPort;
                }
                {
                  type = "smtp";
                  name = "smtp.${mailserver-prefs.domain}";
                  port = mailserver-prefs.smtpPort;
                }
              ];
            };
          };

          nginx.virtualHosts."autoconfig.${mailserver-prefs.domain}" = {
            forceSSL = true;
            enableACME = lib.mkForce false;
            useACMEHost = lib.mkForce mailserver-prefs.domain;
            locations."/".proxyPass = lib.mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
          };
        };
      };
    };
}
