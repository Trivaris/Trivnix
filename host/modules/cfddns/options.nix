{ lib, ... }:
{
  options.hostPrefs.cfddns = {
    enable = lib.mkEnableOption "Cloudflare DDNS service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
