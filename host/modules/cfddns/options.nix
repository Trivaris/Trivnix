{ lib, ... }:
{
  options.hostPrefs.cfddns = {
    enable = lib.mkEnableOption "the Cloudflare DDNS service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
