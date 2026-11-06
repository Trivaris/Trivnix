{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
      secrets = config.sops.secrets;
      acmeUnits = map (service: "acme-${service.domain}.service") config.vars.active-services;
    in
    {
      config = lib.mkIf reverse-proxy-prefs.enable {
        users.users.nginx.extraGroups = [ "acme" ];

        security.acme = {
          acceptTerms = true;
          defaults = {
            credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = secrets.cloudflare-dns-api-token.path;
            credentialFiles."CLOUDFLARE_ZONE_API_TOKEN_FILE" = secrets.cloudflare-zone-api-token.path;
            dnsProvider = "cloudflare";
            email = reverse-proxy-prefs.email;
          };

          certs = builtins.listToAttrs (
            [ (lib.nameValuePair reverse-proxy-prefs.zone { }) ]
            ++ (map (service: lib.nameValuePair service.domain { }) config.vars.active-services)
            ++ (map (
              extraCertDomain: lib.nameValuePair extraCertDomain { }
            ) reverse-proxy-prefs.extraCertDomains)
          );
        };

        systemd.services.nginx = {
          requires = acmeUnits;
          after = acmeUnits;
        };
      };
    };
}
