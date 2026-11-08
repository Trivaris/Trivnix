{
  flake.nixosModules.services-tandoor =
    { lib, ... }:
    {
      options.host.preferences.tandoor = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Tandoor Recipes, a self-hosted recipe manager";
      };
    };
}
