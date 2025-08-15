{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Nextcloud service.";
  reverseProxy = mkReverseProxyOption 8889;
}
