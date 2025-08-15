{
  prefs,
  config,
  activeServices,
}:
{
  acceptTerms = true;
  certs = builtins.listToAttrs (
    map (service: {
      name = service.domain;
      value = {
        dnsProvider = "cloudflare";
        group = "nginx";
        email = prefs.reverseProxy.email;
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
        };
      };
    }) activeServices
  );
}
