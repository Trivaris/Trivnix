{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption "Enable WireGuard server configuration.";
  domain = mkOption {
    type = types.str;
    description = "FQDN of the vpn";
  };
}
