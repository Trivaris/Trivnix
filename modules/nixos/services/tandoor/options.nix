{
  flake.nixosModules.services-tandoor =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.tandoor = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Tandoor Recipes, a self-hosted recipe manager";
      };
    };
}
