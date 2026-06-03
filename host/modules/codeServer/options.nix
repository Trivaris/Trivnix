{ lib, ... }:
{
  options.hostPrefs.codeServer = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption ''
      Launch code-server to provide VS Code over HTTPS.
      Enable when you want remote development through the reverse proxy.
    '';
  };
}
