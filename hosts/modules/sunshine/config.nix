{
  mkReverseProxyOption,
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable Sunshine remote desktop proxy integration.";
  reverseProxy = mkReverseProxyOption 47989;

  hostMac = mkOption {
    type = types.str;
    example = "3C:52:82:4B:00:11";
    description = ''
      MAC address of the computer to send the WoL Packet to.
    '';
  };
}
