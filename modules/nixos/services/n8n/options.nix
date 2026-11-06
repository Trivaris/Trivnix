{
  flake.nixosModules.services-n8n =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.n8n = {
        enable = lib.mkEnableOption "n8n, the automation platform";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
