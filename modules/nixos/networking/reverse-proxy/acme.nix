{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
      secrets = config.sops.secrets;
      acmeUnits = map (service: "acme-${service.domain}.service") config.vars.activeServices;
    in
    {
      config = lib.mkIf reverseProxyPreferences.enable {
        users.users.nginx.extraGroups = [ "acme" ];

        security.acme = {
          acceptTerms = true;
          defaults = {
            credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = secrets.cloudflare-dns-api-token.path;
            credentialFiles."CLOUDFLARE_ZONE_API_TOKEN_FILE" = secrets.cloudflare-zone-api-token.path;
            dnsProvider = "cloudflare";
            email = reverseProxyPreferences.email;
          };

          certs = builtins.listToAttrs (
            [ (lib.nameValuePair reverseProxyPreferences.zone { }) ]
            ++ (map (service: lib.nameValuePair service.domain { }) config.vars.activeServices)
            ++ (map (
              extraCertDomain: lib.nameValuePair extraCertDomain { }
            ) reverseProxyPreferences.extraCertDomains)
          );
        };

        systemd.services.nginx = {
          requires = acmeUnits;
          after = acmeUnits;
        };
      };
    };
}
