{
  config,
  nameValuePair,
  prefs,
}:
let
  body = {
    inherit (prefs.reverseProxy) email;
    dnsProvider = "cloudflare";
    group = "nginx";
    credentialFiles."CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
  };
in
{
  acceptTerms = true;
  certs = builtins.listToAttrs (
    (map (service: nameValuePair service.domain body) config.vars.activeServices)
    ++ (map (extraCertDomain: nameValuePair extraCertDomain body) (
      prefs.reverseProxy.extraCertDomains ++ config.vars.extraCertDomains
    ))
  );
}
