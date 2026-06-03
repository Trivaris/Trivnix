{
  lib,
  config,
  ...
}:
let
  reverseProxyPrefs = config.hostPrefs.reverseProxy;
  cfddnsPrefs = config.hostPrefs.cfddns;
  commonSecrets = "${config.private.secrets}/host/common.yaml";
in
{
  config.sops.secrets = lib.mkIf (reverseProxyPrefs.enable || cfddnsPrefs.enable) {
    cloudflare-zone-api-token = {
      sopsFile = commonSecrets;
      owner = "root";
      group = "root";
    };

    cloudflare-dns-api-token = {
      sopsFile = commonSecrets;
      owner = "root";
      group = "root";
    };
  };
}
