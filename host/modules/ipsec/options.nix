{
  mkEnableOption,
  mkOption,
  mkReverseProxyOption,
  types,
}:
{
  enable = mkEnableOption "Enable WireGuard server configuration.";
  reverseProxy = mkReverseProxyOption { defaultPort = 500; };
  publicKey = mkOption {
    type = types.str;
    description = "Public Key of the client";
  };
}
