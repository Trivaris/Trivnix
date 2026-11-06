{
  flake.nixosModules.networking-reverse-proxy =
    {
      lib,
      config,
      ...
    }:
    let
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
      cfddns-prefs = config.host-prefs.cfddns;
      common-secrets = "${config.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf (reverse-proxy-prefs.enable || cfddns-prefs.enable) {
        cloudflare-zone-api-token = {
          sopsFile = common-secrets;
          owner = "root";
          group = "root";
        };

        cloudflare-dns-api-token = {
          sopsFile = common-secrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
