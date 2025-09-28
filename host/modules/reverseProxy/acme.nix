{
  activeServices,
  config,
  nameValuePair,
  prefs,
}:
{
  acceptTerms = true;
  certs = builtins.listToAttrs (
    map (
      service:
      nameValuePair service.domain {
        inherit (prefs.reverseProxy) email;
        dnsProvider = "cloudflare";
        group = "nginx";
        credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
      }
    ) activeServices
  );
}
