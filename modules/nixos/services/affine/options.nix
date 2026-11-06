{
  flake.nixosModules.services-affine =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.affine = {
        enable = lib.mkEnableOption "Affine, a note taking app";
        sendMails = lib.mkEnableOption "mail account creation. Details still have to be manually entered in the affine admin panel";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
