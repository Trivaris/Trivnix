{ lib, trivnixLib, ... }:
{
  options.hostPrefs.vaultwarden = {
    reverseProxy = trivnixLib.mkReverseProxyOption { defaultPort = 8891; };

    enable = lib.mkEnableOption ''
      Start the Vaultwarden password manager backend on this host.
      Activate when hosting a self-managed Bitwarden-compatible server.
    '';

    sendMails = lib.mkEnableOption ''
      Send mails via the integrated mailserver.
      Also enable and configure prefs.mailserver.
    '';
  };
}
