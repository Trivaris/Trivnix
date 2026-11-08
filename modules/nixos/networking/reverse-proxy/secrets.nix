{
  flake.nixosModules.networking-reverse-proxy =
    {
      lib,
      config,
      ...
    }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
      cfddnsPreferences = config.host.preferences.cfddns;
      commonSecrets = "${config.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf (reverseProxyPreferences.enable || cfddnsPreferences.enable) {
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
    };
}
