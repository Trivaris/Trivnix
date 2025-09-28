{ mkEnableOption, mkReverseProxyOption }:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8889; };
  enable = mkEnableOption ''
    Deploy the Nextcloud application server on this host.
    Choose this when exposing a personal file-sync instance.
  '';
}
