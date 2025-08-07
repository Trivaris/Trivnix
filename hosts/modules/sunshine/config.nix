{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable Sunshine remote desktop proxy integration.";

  hostMac = mkOption {
    type = types.str;
    example = "3C:52:82:4B:00:11";
    description = ''
      MAC address of the Sunshine desktop, used to send Wake-on-LAN packets.
    '';
  };

  hostIP = mkOption {
    type = types.str;
    example = "192.168.1.100";
    description = ''
      IPv4 address of the Sunshine desktop, used by the TCP/UDP proxy and for reachability checks.
    '';
  };
}
