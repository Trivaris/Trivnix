{ lib, ... }:
{
  options.hostPrefs.actual = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption "Enable the private financing and budgeting tool Actual";
  };
}
