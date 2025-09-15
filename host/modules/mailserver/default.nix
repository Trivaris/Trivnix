{
  lib,
  config,
  inputs,
  hostInfos,
  trivnixLib,
  ...
}:
let
  inherit (prefs.mailserver.reverseProxy) domain;
  inherit (lib)
    mkIf
    pipe
    mapAttrs'
    nameValuePair
    splitString
    tail
    head
    toInt
    concatStringsSep
    findFirst
    hasSuffix
    ;

  prefs = config.hostPrefs;

  baseDomain = pipe domain [
    (splitString ".")
    tail
    (concatStringsSep ".")
  ];

  loginAccounts = pipe inputs.trivnixPrivate.emailAccounts.${prefs.mainUser} [
    (mapAttrs' (name: value: nameValuePair name (value // { profileName = name; })))
    builtins.attrValues
    (findFirst (account: hasSuffix "@${domain}" account.address) (
      throw "Email Server enabled but no email accounts set!"
    ))
    (account: {
      ${account.userName} = {
        hashedPasswordFile =
          config.home-manager.users.${prefs.mainUser}.sops.secrets."email-passwords/${account.profileName}-hashed".path;

        aliases = [
          "@${domain}"
          "@${baseDomain}"
        ];
      };
    })
  ];
in
{
  options.hostPrefs.mailserver = import ./options.nix {
    inherit (lib) mkEnableOption types mkOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.mailserver.enable {
    mailserver = {
      inherit (prefs.mailserver) enablePop3;
      inherit loginAccounts;

      enable = true;
      fqdn = domain;
      certificateScheme = "acme-nginx";
      enablePop3Ssl = prefs.mailserver.enablePop3;

      domains = [
        baseDomain
        domain
      ];

      certificateDomains = [
        "imap.${baseDomain}"
        "smtp.${baseDomain}"
        (mkIf prefs.mailserver.enablePop3 "pop3.${baseDomain}")
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
  };
}
