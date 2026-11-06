{
  flake.nixosModules.services-actual =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.actual = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Actual, the private financing and budgeting tool";
      };
    };
}
