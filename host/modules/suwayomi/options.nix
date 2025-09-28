{ mkEnableOption, mkReverseProxyOption }:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8890; };
  enable = mkEnableOption ''
    Host the Suwayomi (Tachidesk) manga server on this machine.
    Turn on when exposing the reader via the shared reverse proxy.
  '';
}
