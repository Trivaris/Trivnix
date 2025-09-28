{
  mkEnableOption,
  mkOption,
  mkReverseProxyOption,
  types,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 47989; };

  enable = mkEnableOption ''
    Enable the Sunshine game-streaming service behind the reverse proxy.
    Use this for hosts that broadcast desktops to Moonlight clients.
  '';

  hostMac = mkOption {
    type = types.str;
    example = "3C:52:82:4B:00:11";
    description = ''
      Ethernet MAC address targeted by Sunshine wake-on-LAN packets.
      Needed so Moonlight clients can power on the machine remotely.
    '';
  };
}
