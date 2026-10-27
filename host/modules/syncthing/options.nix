{
  lib,
  ...
}:
{
  options.hostPrefs.syncthing = {
    enable = lib.mkEnableOption "Syncthing, a file synchronization service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
