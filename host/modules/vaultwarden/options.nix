{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8891; };

  enable = mkEnableOption ''
    Start the Vaultwarden password manager backend on this host.
    Activate when hosting a self-managed Bitwarden-compatible server.
  '';
}
