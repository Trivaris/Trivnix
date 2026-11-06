{
  flake.nixosModules.services-syncthing =
    {
      lib,
      ...
    }:
    {
      options.host-prefs.syncthing = {
        enable = lib.mkEnableOption "Syncthing, a file synchronization service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
