{
  lib,
  config,
  ...
}:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  cfddnsPrefs = config.hostPrefs.cfddns;
in
{
  config.sops.secrets = lib.mkIf (reverseProxyPrefs.enable || cfddnsPrefs.enable) {
    cloudflare-zone-api-token = {
      owner = "root";
      group = "root";
    };

    cloudflare-dns-api-token = {
      owner = "root";
      group = "root";
    };
  };
}