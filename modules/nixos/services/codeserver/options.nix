{
  flake.nixosModules.services-code-server =
    { lib, ... }:
    {
      options.host-prefs.codeserver = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Code-Server for remote VS Code access over HTTPS";
      };
    };
}
