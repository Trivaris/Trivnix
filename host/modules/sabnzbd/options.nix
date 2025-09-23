{ mkEnableOption, mkReverseProxyOption }:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8899; };
  enable = mkEnableOption ''Enable the sabnzbd service'';
}
