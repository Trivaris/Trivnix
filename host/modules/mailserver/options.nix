{
  mkEnableOption,
  mkOption,
  types,
}:
let
  mkStrOption =
    description:
    mkOption {
      inherit description;
      type = types.str;
    };
in
{
  enable = mkEnableOption "Enable email server";
  enablePop3 = mkEnableOption "Enable pop3 email";
  enableIpV6 = mkEnableOption "Enable email over ipv6";
  ipV6Address = mkStrOption "The ipv6 Address of your mail server";
  ipV6Interface = mkStrOption "The ipv6 interface of your mail server";
  domain = mkStrOption "The domain your server will run on";
  baseDomain = mkStrOption "The base domain that you control";
}
