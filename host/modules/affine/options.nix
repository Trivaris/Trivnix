{
  lib,
  ...
}:
{
  options.hostPrefs.affine = {
    enable = lib.mkEnableOption "Affine, a note-taking app";
    sendMails = lib.mkEnableOption "mail account creation for Affine; details must still be entered in its admin panel";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
