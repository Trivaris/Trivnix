{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable forgejo server";
  reverseProxy = mkReverseProxyOption { defaultPort = 3000; };
}
