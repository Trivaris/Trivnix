{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.codeServer = import ./config.nix { inherit (lib) mkEnableOption; inherit (trivnixLib) mkReverseProxyOption; };

  config = mkIf (cfg.codeServer.enable) {
    services.code-server = {
      enable = true;
      port = cfg.codeServer.reverseProxy.port;
      host = cfg.codeServer.reverseProxy.ipAddress;
      user = "trivaris";
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
}
