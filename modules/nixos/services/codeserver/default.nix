{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.services-code-server =
    { config, lib, ... }:
    let
      codeserver-prefs = config.host-prefs.codeserver;
    in
    {
      config = lib.mkIf codeserver-prefs.enable {
        services.code-server = {
          enable = true;
          inherit (codeserver-prefs.reverseProxy) port;
          host = codeserver-prefs.reverseProxy.domain;
          user = config.host-prefs.mainUser;
          hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$VERtWDdiZFhGZk11Y044Sm53NllKdXVQZ3VVPQ$c9o3xk7W5ecGG1H6pgAkcUFtwmJloR2Cz42RooSb/BI";
        };
      };
    };
}
