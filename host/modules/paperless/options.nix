{
  lib,
  ...
}:
{
  options.hostPrefs.paperless = {
    enable = lib.mkEnableOption "Paperless, a document management software";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
