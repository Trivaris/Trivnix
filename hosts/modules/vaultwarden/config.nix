{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Vaultwarden password manager server.";
  reverseProxy = mkReverseProxyOption 8891;
}
