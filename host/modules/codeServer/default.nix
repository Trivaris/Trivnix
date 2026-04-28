{ config, lib, ... }:
let
  codeServerPrefs = config.hostPrefs.codeServer;
in
{
  config = lib.mkIf codeServerPrefs.enable {
    services.code-server = {
      enable = true;
      inherit (codeServerPrefs.reverseProxy) port;
      host = codeServerPrefs.reverseProxy.ipAddress;
      user = config.hostPrefs.mainUser;
      hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
    };
  };
}
