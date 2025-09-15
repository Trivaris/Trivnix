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
    ;

  prefs = config.hostPrefs;

  loginAccounts = pipe inputs.trivnixPrivate.emailAccounts.${prefs.mainUser} [
    (mapAttrs' (name: value: nameValuePair name (value // { profileName = name; })))
    builtins.attrValues
    (findFirst (account: hasSuffix "@${prefs.mailserver.domain}" account.address) (
      throw "Email Server enabled but no email accounts with addresses ending on @${prefs.mailserver.domain} set!"
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
      fqdn = prefs.mailserver.domain;
      certificateScheme = "acme-nginx";
      enablePop3Ssl = prefs.mailserver.enablePop3;

      dkimSelector = "default";
      dkimKeyType = "ed25519";

      domains = builtins.attrValues {
        inherit (prefs.mailserver) baseDomain domain;
      };

      certificateDomains = [
        "imap.${prefs.mailserver.baseDomain}"
        "smtp.${prefs.mailserver.baseDomain}"
        (mkIf prefs.mailserver.enablePop3 "pop3.${prefs.mailserver.baseDomain}")
      ];

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

    services.automx2 = {
      enable = true;
      domain = prefs.mailserver.baseDomain;
      settings = {
        provider = prefs.mailserver.providerName;

        domains = builtins.attrValues {
          inherit (prefs.mailserver) baseDomain domain;
        };

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
  };
}
