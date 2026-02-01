{ lib, ... }:
{
  options.hostPrefs.actual = {
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8080; };
    enable = lib.mkEnableOption "Enable the private financing and budgeting tool Actual";
  };
}
