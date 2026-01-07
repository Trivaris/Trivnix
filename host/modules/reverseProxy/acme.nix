{ config, lib, ... }:
let
  prefs = config.hostPrefs;
  acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
  body = {
    inherit (prefs.reverseProxy) email;
    dnsProvider = "cloudflare";
    group = "nginx";
    credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
  };
in
{
  config = lib.mkIf prefs.reverseProxy.enable {
    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      certs = builtins.listToAttrs (
        (map (service: lib.nameValuePair service.domain body) config.vars.activeServices)
        ++ (map (extraCertDomain: lib.nameValuePair extraCertDomain body) (
          prefs.reverseProxy.extraCertDomains ++ config.vars.extraCertDomains
        ))
      );
    };

    systemd.services.nginx = {
      requires = acmeUnits;
      after = acmeUnits;
    };
  };
}
