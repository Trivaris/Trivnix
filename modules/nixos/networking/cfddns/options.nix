{
  flake.nixosModules.networking-cfddns =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.cfddns = {
        enable = lib.mkEnableOption "Cloudflare DDNS service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
