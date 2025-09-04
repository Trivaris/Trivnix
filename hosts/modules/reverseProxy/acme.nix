{
  prefs,
  config,
  activeServices,
  nameValuePair,
}:
{
  acceptTerms = true;
  certs = builtins.listToAttrs (
    map (
      service:
      nameValuePair service.domain {
        dnsProvider = "cloudflare";
        group = "nginx";
        email = prefs.reverseProxy.email;
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
        };
      }
    ) activeServices
  );
}
