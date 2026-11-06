{
  flake.nixosModules.services-forgejo =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.forgejo = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Forgejo Git hosting service";
        sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
      };
    };
}
