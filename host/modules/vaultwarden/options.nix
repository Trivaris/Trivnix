{ lib, ... }:
{
  options.hostPrefs.vaultwarden = {
    reverseProxy = lib.mkReverseProxyOption;

    enable = lib.mkEnableOption "Vaultwarden, a password manager backend";

    sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
  };
}
