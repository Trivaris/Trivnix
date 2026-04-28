{
  lib,
  ...
}:
{
  options.hostPrefs.n8n = {
    enable = lib.mkEnableOption "n8n, the automation platform";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 5678; };
  };
}