{
  mkOption,
  mkEnableOption,
  types,
}:
{
  enable = mkEnableOption ''Enable the Glances API'';
  port = mkOption {
    type = types.port;
    default = 61208;
  };
}
