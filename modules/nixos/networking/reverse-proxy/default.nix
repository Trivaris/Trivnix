{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverse-proxy-prefs = config.host-prefs.reverse-proxy;
      allowedTCPPorts =
        (map (service: service.externalPort) config.vars.active-services)
        ++ lib.optionals reverse-proxy-prefs.dumbPipes.enable (
          map (tcpForward: tcpForward.listenPort) (
            builtins.attrValues reverse-proxy-prefs.dumbPipes.portForwards
          )
        );
    in
    {
      config = lib.mkIf reverse-proxy-prefs.enable {
        networking.firewall.allowedTCPPorts = allowedTCPPorts;

        users.users.nginx.extraGroups = [ "acme" ];
        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
          appendHttpConfig = lib.mkAfter ''
            map $http_upgrade $connection_upgrade {
              default upgrade;
              \'\'      close;
            }
          '';
        };
      };
    };
}
