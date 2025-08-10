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

  port = mkOption {
    type = types.nullOr types.port;
    default = null;
    example = 47989;
    description = ''
      Base port -- others used are offset from this one.
      See https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/advanced_usage.html#port for details.
    '';
  };

  domain = mkOption {
    type = types.str;
    description = ''
      FQDN to access the Sunshine instance.
      Used in web configuration and TLS certificate issuance.
    '';
    example = "sunshine.example.com";
  };
}
