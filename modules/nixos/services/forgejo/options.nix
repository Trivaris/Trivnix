{
  flake.nixosModules.services-forgejo =
    { lib, ... }:
    {
      options.host.preferences.forgejo = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Forgejo Git hosting service";
        sendMails = lib.mkEnableOption "Mail delivery through the integrated mailserver";
      };
    };
}
