{
  flake.nixosModules.services-paperless =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.paperless = {
        enable = lib.mkEnableOption "Paperless, a document management service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
