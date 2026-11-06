{
  flake.nixosModules.services-actual =
    { lib, ... }:
    {
      options.host-prefs.actual = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Actual, the private financing and budgeting tool";
      };
    };
}
