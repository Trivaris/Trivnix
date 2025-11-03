{
  config,
  hostInfos,
  lib,
  ...
}:
let
  inherit (lib) mkForce;
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
      certificateScheme = "acme-nginx";
      dkimSelector = "dkim";
      dkimKeyType = "ed25519";

      domains = [
        prefs.mailserver.baseDomain
        prefs.mailserver.domain
      ];

      certificateDomains = [
        prefs.mailserver.domain
      ]
      ++ (map (name: "${name}.${prefs.mailserver.baseDomain}") [
        "imap"
        "smtp"
        "autoconfig"
        "autodiscover"
      ]);

      stateVersion = lib.pipe hostInfos.stateVersion [
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
        enableACME = mkForce false;
        useACMEHost = mkForce prefs.mailserver.baseDomain;
        locations."/".proxyPass = mkForce "http://127.0.0.1:${toString config.services.automx2.port}";
      };
    };
  };
}
