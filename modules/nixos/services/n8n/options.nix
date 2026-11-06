{
  flake.nixosModules.services-n8n =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.n8n = {
        enable = lib.mkEnableOption "n8n, the automation platform";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
