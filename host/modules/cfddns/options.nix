{ lib, ... }:
{
  options.hostPrefs.cfddns = {
    enable = lib.mkEnableOption "Enable the cloudflare ddns server";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
