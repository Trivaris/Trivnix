{
  flake.nixosModules.networking-cfddns =
    {
      config,
      lib,
      ...
    }:
    let
      cfddns-prefs = config.host-prefs.cfddns;
    in
    {
      config = lib.mkIf cfddns-prefs.enable {
        virtualisation.oci-containers.backend = "docker";
        virtualisation.oci-containers.containers."cfddns" = {
          image = "ghcr.io/l480/cloudflare-dyndns:latest";

          ports = [
            "${toString cfddns-prefs.reverseProxy.port}:80"
          ];

          extraOptions = [
            "--pull=always"
            "--name=cfddns"
          ];
        };
      };
    };
}
