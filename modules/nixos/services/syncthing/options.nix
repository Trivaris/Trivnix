{
  flake.nixosModules.services-syncthing =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.syncthing = {
        enable = lib.mkEnableOption "Syncthing, a file syncronization service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
