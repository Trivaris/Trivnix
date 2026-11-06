{
  flake.nixosModules.services-paperless =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.paperless = {
        enable = lib.mkEnableOption "Paperless, a document management service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
