{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Nextcloud service.";
  reverseProxy = mkReverseProxyOption { defaultPort = 8889; };
}
