{ lib, trivnixLib, ... }:
{
  options.hostPrefs.actual = {
    reverseProxy = trivnixLib.mkReverseProxyOption { defaultPort = 8080; };
    enable = lib.mkEnableOption "Enable the private financing and budgeting tool Actual";
  };
}
