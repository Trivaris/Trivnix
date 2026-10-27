{
  lib,
  ...
}:
{
  options.hostPrefs.paperless = {
    enable = lib.mkEnableOption "Paperless, a document management service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
