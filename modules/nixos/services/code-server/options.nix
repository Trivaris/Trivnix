{
  flake.nixosModules.services-code-server =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.codeServer = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Code-Server for remote VS Code access over HTTPS";
      };
    };
}
