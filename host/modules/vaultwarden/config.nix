{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Vaultwarden password manager server";
  reverseProxy = mkReverseProxyOption { defaultPort = 8891; };
}
