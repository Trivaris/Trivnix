{
  flake.nixosModules.services-tandoor =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.tandoor = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Tandoor Recipes, a self-hosted recipe manager";
      };
    };
}
