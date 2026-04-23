{
  lib,
  ...
}:
{
  options.hostPrefs.affine = {
    enable = lib.mkEnableOption "Affine, a note taking app";
    sendMails = lib.mkEnableOption "mail account creation. Details still have to be manually entered in the affine admin panel";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 3010; };
  };
}