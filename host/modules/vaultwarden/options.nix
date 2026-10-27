{ lib, ... }:
{
  options.hostPrefs.vaultwarden = {
    reverseProxy = lib.mkReverseProxyOption;

    enable = lib.mkEnableOption ''
      the Vaultwarden password manager backend on this host.
      Use it when hosting a self-managed Bitwarden-compatible server.
    '';

    sendMails = lib.mkEnableOption ''
      mail delivery through the integrated mailserver.
      Configure `hostPrefs.mailserver` separately.
    '';
  };
}
