{
  flake.nixosModules.services-code-server =
    { config, lib, ... }:
    let
      codeserverPreferences = config.host.preferences.codeserver;
    in
    {
      config = lib.mkIf codeserverPreferences.enable {
        services.code-server = {
          enable = true;
          inherit (codeserverPreferences.reverseProxy) port;
          host = codeserverPreferences.reverseProxy.domain;
          user = config.host.preferences.mainUser;
          hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
        };
      };
    };
}
