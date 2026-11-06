{
  flake.nixosModules.services-syncthing =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.syncthing = {
        enable = lib.mkEnableOption "Syncthing, a file synchronization service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
