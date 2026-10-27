{ lib, ... }:
{
  options.hostPrefs.actual = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption "Actual, the private financing and budgeting tool";
  };
}
