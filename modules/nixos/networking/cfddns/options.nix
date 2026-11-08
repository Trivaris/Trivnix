{
  flake.nixosModules.networking-cfddns =
    { lib, ... }:
    {
      options.host.preferences.cfddns = {
        enable = lib.mkEnableOption "Cloudflare DDNS service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
