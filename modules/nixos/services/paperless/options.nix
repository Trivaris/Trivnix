{
  flake.nixosModules.services-paperless =
    {
      lib,
      ...
    }:
    {
      options.host.preferences.paperless = {
        enable = lib.mkEnableOption "Paperless, a document management service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
