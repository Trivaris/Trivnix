{
  flake.nixosModules.networking-cfddns =
    { lib, ... }:
    {
      options.host-prefs.cfddns = {
        enable = lib.mkEnableOption "Cloudflare DDNS service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
