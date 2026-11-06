{
  flake.nixosModules.services-vaultwarden =
    { lib, ... }:
    {
      options.host-prefs.vaultwarden = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Vaultwarden, a password manager backend";
        sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
      };
    };
}
