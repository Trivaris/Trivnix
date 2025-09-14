{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable email server";
  reverseProxy = mkReverseProxyOption { defaultPort = 25; };
}
