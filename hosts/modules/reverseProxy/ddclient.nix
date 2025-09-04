{
  prefs,
  config,
  activeServices,
}:
{
  enable = true;
  protocol = "cloudflare";
  usev4 = "webv4,webv4=ipify-ipv4";
  ssl = true;
  verbose = true;
  zone = prefs.reverseProxy.zone;
  domains = (map (service: service.domain) activeServices) ++ prefs.reverseProxy.extraDomains;
  username = "token";
  passwordFile = config.sops.secrets.cloudflare-api-account-token.path;
}
