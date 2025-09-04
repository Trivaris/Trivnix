{
  mkEnableOption,
}:
{
  enable = mkEnableOption "Enable the Wireguard client";
  enableServer = mkEnableOption "Enable the Wireguard server";
}
