{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.codeServer = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.codeServer.enable {
    services.code-server = {
      enable = true;
      inherit (prefs.codeServer.reverseProxy) port;
      host = prefs.codeServer.reverseProxy.ipAddress;
      user = prefs.mainUser;
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
}
