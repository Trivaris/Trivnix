{
  flake.nixosModules.services-paperless =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.paperless = {
        enable = lib.mkEnableOption "Paperless, a document management software";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
