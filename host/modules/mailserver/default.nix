{
  lib,
  config,
  inputs,
  hostInfos,
  ...
}:
let
  inherit (lib)
    mkIf
    pipe
    mapAttrs'
    nameValuePair
    splitString
    head
    toInt
    findFirst
    hasSuffix
    mkForce
    ;

  prefs = config.hostPrefs;

  loginAccounts = pipe inputs.trivnixPrivate.emailAccounts.${prefs.mainUser} [
    (mapAttrs' (name: value: nameValuePair name (value // { profileName = name; })))
    builtins.attrValues
    (findFirst (account: hasSuffix "@${prefs.mailserver.baseDomain}" account.address) (
      throw "Email Server enabled but no email accounts with addresses ending on @${prefs.mailserver.baseDomain} set!"
    ))
    (account: {
      ${account.userName} = {
        hashedPasswordFile =
          config.home-manager.users.${prefs.mainUser}.sops.secrets."email-passwords/${account.profileName}-hashed".path;

        aliases = [
          "@${prefs.mailserver.domain}"
          "@${prefs.mailserver.baseDomain}"
        ];
      };
    })
  ];
in
{
  options.hostPrefs.mailserver = import ./options.nix {
    inherit (lib) mkEnableOption types mkOption;
  };

  config = mkIf prefs.mailserver.enable {
    mailserver = {
      inherit (prefs.mailserver) enablePop3;
      inherit loginAccounts;

      enable = true;
      fqdn = prefs.mailserver.baseDomain;
      certificateScheme = "acme-nginx";
      enablePop3Ssl = prefs.mailserver.enablePop3;
      dkimSelector = "dkim";
      dkimKeyType = "ed25519";
      domains = [ prefs.mailserver.baseDomain ];

      certificateDomains = [
        prefs.mailserver.domain
      ]
      ++ (map (name: "${name}.${prefs.mailserver.baseDomain}") (
        [
          "imap"
          "smtp"
          "autoconfig"
          "autodiscovery"
        ]
        ++ (if prefs.mailserver.enablePop3 then [ "pop3" ] else [ ])
      ));

      stateVersion = pipe hostInfos.stateVersion [
        (splitString ".")
        head
        toInt
      ];
    };

    networking = mkIf prefs.mailserver.enableIpV6 {
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
              port = 993;
            }
            {
              type = "smtp";
              name = "smtp.${prefs.mailserver.baseDomain}";
              port = 587;
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
