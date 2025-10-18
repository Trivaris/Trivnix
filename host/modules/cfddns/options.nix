{ mkEnableOption, mkReverseProxyOption }:
{
  enable = mkEnableOption "Enable the cloudflare ddns server";
  reverseProxy = mkReverseProxyOption { defaultPort = 8892; };
}
