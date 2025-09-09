{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Suwayomi server (Tachidesk) service";
  reverseProxy = mkReverseProxyOption { defaultPort = 8890; };
}
