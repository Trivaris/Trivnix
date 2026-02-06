{ config, lib, ... }:
let
  prefs = config.hostPrefs;
  acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
in
{
  config = lib.mkIf prefs.reverseProxy.enable {
    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults = {
        credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-dns-api-token.path;
        credentialFiles."CLOUDFLARE_ZONE_API_TOKEN_FILE" = config.sops.secrets.cloudflare-zone-api-token.path;
        dnsProvider = "cloudflare";
        email = prefs.reverseProxy.email;
      };

      certs = builtins.listToAttrs (
        (map (service: lib.nameValuePair service.domain {}) config.vars.activeServices) ++
        (map (extraCertDomain: lib.nameValuePair extraCertDomain {}) prefs.reverseProxy.extraCertDomains)
      );
    };

    systemd.services.nginx = {
      requires = acmeUnits;
      after = acmeUnits;
    };
  };
}
