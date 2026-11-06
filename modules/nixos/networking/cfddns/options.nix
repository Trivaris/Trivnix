{
  flake.nixosModules.networking-cfddns =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.cfddns = {
        enable = lib.mkEnableOption "Cloudflare DDNS service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
