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
    ;

  prefs = config.hostPrefs;

  baseDomain = pipe domain [
    (lib.splitString ".")
    lib.tail
    (lib.concatStringsSep ".")
  ];

  loginAccounts = mapAttrs' (
    name: value:
    nameValuePair value.personal.address {
      hashedPasswordFile = config.home-manager.users.${name}.sops.secrets."email-passwords/personal".path;
      aliases = [ "@${domain}" ];
    }
  ) inputs.trivnixPrivate.emailAccounts;
in
{
  options.hostPrefs.mailserver = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.mailserver.enable {
    mailserver = {
      inherit loginAccounts;
      enable = true;
      fqdn = domain;
      domains = [ baseDomain ];
      certificateScheme = "acme-nginx";
      stateVersion = pipe hostInfos.stateVersion [
        (lib.splitString ".")
        lib.head
        lib.toInt
      ];
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = prefs.reverseProxy.email;
    };
  };
}
