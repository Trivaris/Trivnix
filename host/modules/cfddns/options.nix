{ lib, trivnixLib, ... }:
{
  options.hostPrefs.cfddns = {
    enable = lib.mkEnableOption "Enable the cloudflare ddns server";
    reverseProxy = trivnixLib.mkReverseProxyOption { defaultPort = 8892; };
  };
}
