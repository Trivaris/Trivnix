{
  lib,
  ...
}:
{
  options.hostPrefs.syncthing = {
    enable = lib.mkEnableOption "Syncthing, a file syncronization service";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8384; };
  };
}