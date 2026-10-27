{ lib, ... }:
{
  options.hostPrefs.forgejo = {
    reverseProxy = lib.mkReverseProxyOption;

    enable = lib.mkEnableOption "Forgejo Git hosting service";

    sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
  };
}
