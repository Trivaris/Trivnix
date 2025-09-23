{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 3000; };

  enable = mkEnableOption ''
    Run the Forgejo git hosting service locally.
    Enable to provide a self-hosted Forgejo instance behind the reverse proxy.
  '';

  sendMails = mkEnableOption ''
    Send mails via the integrated mailserver.
    Also enable and configure prefs.mailserver.
  '';
}
