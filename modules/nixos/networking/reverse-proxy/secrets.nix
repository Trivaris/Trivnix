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
    in
    {
      config.sops.secrets = lib.mkIf (reverseProxyPreferences.enable || cfddnsPreferences.enable) {
        cloudflare-zone-api-token = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "root";
          group = "root";
        };

        cloudflare-dns-api-token = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "root";
          group = "root";
        };
      };
    };
}
