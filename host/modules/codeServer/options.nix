{ lib, ... }:
{
  options.hostPrefs.codeServer = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption "Code-Server for remote VS Code access over HTTPS";
  };
}
