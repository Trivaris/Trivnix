{ lib, ... }:
{
  options.hostPrefs.actual = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption "the private financing and budgeting tool Actual";
  };
}
