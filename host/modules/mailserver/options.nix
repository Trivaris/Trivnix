{
  mkReverseProxyOption,
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable email server";
  reverseProxy = mkReverseProxyOption { defaultPort = 25; };
  enablePop3 = mkEnableOption "Enable pop3 email";
  enableIpV6 = mkEnableOption "Enable email over ipv6";

  ipV6Address = mkOption {
    type = types.str;
    default = "";
  };

  ipV6Interface = mkOption {
    type = types.str;
    default = "";
  };
}
