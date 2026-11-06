{
  flake.nixosModules.services-actual =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.actual = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Enable the private financing and budgeting tool Actual";
      };
    };
}
