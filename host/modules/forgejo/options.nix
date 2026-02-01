{ lib, ... }:
{
  options.hostPrefs.forgejo = {
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 3000; };

    enable = lib.mkEnableOption ''
      Run the Forgejo git hosting service locally.
      Enable to provide a self-hosted Forgejo instance behind the reverse proxy.
    '';

    sendMails = lib.mkEnableOption ''
      Send mails via the integrated mailserver.
      Also enable and configure prefs.mailserver.
    '';
  };
}
