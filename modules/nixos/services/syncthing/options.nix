{
  flake.nixosModules.services-syncthing =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.syncthing = {
        enable = lib.mkEnableOption "Syncthing, a file synchronization service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
