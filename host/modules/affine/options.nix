{
  lib,
  ...
}:
{
  options.hostPrefs.affine = {
    enable = lib.mkEnableOption "Affine, a note taking app";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 3010; };
  };
}