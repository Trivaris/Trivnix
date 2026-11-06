{
  flake.nixosModules.services-vaultwarden =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.vaultwarden = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Vaultwarden, a password manager backend";
        sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
      };
    };
}
