{ lib, ... }:
{
  options.hostPrefs.forgejo = {
    reverseProxy = lib.mkReverseProxyOption;

    enable = lib.mkEnableOption ''
      the Forgejo Git hosting service.
      It is exposed through the configured reverse proxy.
    '';

    sendMails = lib.mkEnableOption ''
      mail delivery through the integrated mailserver.
      Configure `hostPrefs.mailserver` separately.
    '';
  };
}
