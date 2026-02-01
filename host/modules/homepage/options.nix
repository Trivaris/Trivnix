{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hostPrefs.homepage = {
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8082; };

    serviceGroups = lib.mkOption {
      inherit (pkgs.formats.yaml { }) type;
      default = [
        {
          Services = map (service: {
            ${service.name} = {
              description = service.name;
              href = "https://${service.domain}";
            };
          }) config.vars.activeServices;
        }
      ];
    };

    enable = lib.mkEnableOption ''
      Run the hompage service.
      Enable to provide a self-hosted Homepage instance behind a reverse proxy to manage all other services.
    '';
  };
}
