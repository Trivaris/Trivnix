{ lib, ... }:
{
  options.hostPrefs.codeServer = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption ''
      code-server for remote VS Code access over HTTPS.
      It is exposed through the configured reverse proxy.
    '';
  };
}
