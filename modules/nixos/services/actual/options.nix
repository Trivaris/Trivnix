{
  flake.nixosModules.services-actual =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.actual = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Actual, the private financing and budgeting tool";
      };
    };
}
