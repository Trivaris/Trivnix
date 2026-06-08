{ config, lib, ... }:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  secrets = config.sops.secrets;
  acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
in
{
  config = lib.mkIf reverseProxyPrefs.enable {
    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults = {
        credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = secrets.cloudflare-dns-api-token.path;
        credentialFiles."CLOUDFLARE_ZONE_API_TOKEN_FILE" = secrets.cloudflare-zone-api-token.path;
        dnsProvider = "cloudflare";
        email = reverseProxyPrefs.email;
      };

      certs = builtins.listToAttrs (
        [ (lib.nameValuePair reverseProxyPrefs.zone { group = "nginx"; }) ]
        ++ (map (service: lib.nameValuePair service.domain { group = "nginx"; }) config.vars.activeServices)
        ++ (map (extraCertDomain: lib.nameValuePair extraCertDomain { group = "nginx"; }) reverseProxyPrefs.extraCertDomains)
      );
    };

    systemd.services.nginx = {
      requires = acmeUnits;
      after = acmeUnits;
    };
  };
}
