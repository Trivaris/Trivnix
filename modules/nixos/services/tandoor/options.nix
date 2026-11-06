{
  flake.nixosModules.services-tandoor =
    { lib, ... }:
    {
      options.host-prefs.tandoor = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Tandoor Recipes, a self-hosted recipe manager";
      };
    };
}
