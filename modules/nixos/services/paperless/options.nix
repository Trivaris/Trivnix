{
  flake.nixosModules.services-paperless =
    {
      lib,
      ...
    }:
    {
      options.host-prefs.paperless = {
        enable = lib.mkEnableOption "Paperless, a document management service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
