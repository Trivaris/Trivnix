{
  mkReverseProxyOption,
  mkEnableOption,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8891; };

  enable = mkEnableOption ''
    Start the Vaultwarden password manager backend on this host.
    Activate when hosting a self-managed Bitwarden-compatible server.
  '';

  sendMails = mkEnableOption ''
    Send mails via the integrated mailserver.
    Also enable and configure prefs.mailserver.
  '';
}
