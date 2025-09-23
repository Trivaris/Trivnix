{
  activeServices,
  mkReverseProxyOption,
  mkEnableOption,
  mkOption,
  pkgs,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 8082; };

  serviceGroups = mkOption {
    inherit (pkgs.formats.yaml { }) type;
    default = [
      {
        Services = map (service: {
          ${service.name} = {
            description = service.name;
            href = "https://${service.domain}";
          };
        }) activeServices;
      }
    ];
  };

  enable = mkEnableOption ''
    Run the hompage service.
    Enable to provide a self-hosted Homepage instance behind a reverse proxy to manage all other services.
  '';
}
