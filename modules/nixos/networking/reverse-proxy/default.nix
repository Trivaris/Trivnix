{
  flake.nixosModules.networking-reverse-proxy =
    { config, lib, ... }:
    let
      reverseProxyPreferences = config.host.preferences.reverseProxy;
      allowedTCPPorts =
        (map (service: service.externalPort) config.vars.activeServices)
        ++ lib.optionals reverseProxyPreferences.dumbPipes.enable (
          map (tcpForward: tcpForward.listenPort) (
            builtins.attrValues reverseProxyPreferences.dumbPipes.portForwards
          )
        );
    in
    {
      config = lib.mkIf reverseProxyPreferences.enable {
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
