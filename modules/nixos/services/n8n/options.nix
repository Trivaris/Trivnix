{
  flake.nixosModules.services-n8n =
    {
      lib,
      ...
    }:
    {
      options.host.preferences.n8n = {
        enable = lib.mkEnableOption "n8n, the automation platform";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
