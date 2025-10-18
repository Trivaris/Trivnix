{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption ''
    Enable WireGuard server configuration.
  '';

  port = mkOption {
    type = types.port;
    default = 51820;
    description = "Port where the server runs on.";
  };

  publicKey = mkOption {
    type = types.str;
    description = "Public Key of the client";
  };
}
