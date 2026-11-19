{
  flake.nixosModules.networking-pihole =
    {
      config,
      lib,
      ...
    }:
    let
      piholePreferences = config.host.preferences.pihole;
      wgPrefs = config.host.preferences.wireguard;
      wgIp = config.host.vars.wireguard-address;
    in
    {
      config = lib.mkIf piholePreferences.enable {
        host.preferences.pihole.reverseProxy.allowFrom =
          if piholePreferences.wireguardOnly then
            lib.mkForce [ "${wgPrefs.subnet}/${toString wgPrefs.subnetMask}" ]
          else
            [ ];

        services = {
          pihole-ftl = {
            enable = true;
            settings.dns = {
              hosts = lib.mkIf piholePreferences.wireguardOnly [
                "${wgIp} ${piholePreferences.reverseProxy.domain}"
              ];
              upstreams = [
                "9.9.9.9"
                "149.112.112.112"
              ];
              interface = lib.mkIf piholePreferences.wireguardOnly wgPrefs.interfaceName;
              listeningMode = lib.mkIf piholePreferences.wireguardOnly "BIND";
            };
          };

          pihole-web = {
            enable = true;
            hostName = piholePreferences.reverseProxy.domain;
            ports = [
              (
                if piholePreferences.wireguardOnly then
                  "${wgIp}:${toString piholePreferences.reverseProxy.port}"
                else
                  piholePreferences.reverseProxy.port
              )
            ];
          };

          nginx = lib.mkIf piholePreferences.reverseProxy.enable {
            streamConfig = ''
              server {
                listen ${if piholePreferences.wireguardOnly then wgIp else "127.0.0.1"}:853 ssl;
                proxy_pass ${if piholePreferences.wireguardOnly then wgIp else "127.0.0.1"}:53;

                ssl_certificate /var/lib/acme/${piholePreferences.reverseProxy.domain}/fullchain.pem;
                ssl_certificate_key /var/lib/acme/${piholePreferences.reverseProxy.domain}/key.pem;
              }
            '';
          };
        };
      };
    };
}
