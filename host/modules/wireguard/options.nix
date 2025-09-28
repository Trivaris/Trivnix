{ mkEnableOption }:
{
  enable = mkEnableOption ''
    Enable WireGuard client configuration sourced from trivnixPrivate.
    Adds wg-quick interfaces and opens UDP ports for remote access.
  '';

  enableServer = mkEnableOption ''
    Reserve this host for running a WireGuard server in the future.
    No server config is emitted yet; keep false unless server support lands.
  '';
}
