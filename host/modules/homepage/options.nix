{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hostPrefs.homepage = {
    reverseProxy = lib.mkReverseProxyOption;

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
      description = ''
        Homepage service groups written to the generated dashboard configuration.
        The default lists services registered with the shared reverse proxy.
      '';
    };

    enable = lib.mkEnableOption ''
      the self-hosted Homepage service behind a reverse proxy.
      It provides a dashboard for the other configured services.
    '';
  };
}
