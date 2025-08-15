{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Suwayomi server (Tachidesk) service.";
  reverseProxy = mkReverseProxyOption 8890;
}
