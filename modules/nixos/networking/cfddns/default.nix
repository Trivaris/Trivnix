{
  flake.nixosModules.networking-cfddns =
    {
      config,
      lib,
      ...
    }:
    let
      cfddnsPreferences = config.host.preferences.cfddns;
    in
    {
      config = lib.mkIf cfddnsPreferences.enable {
        virtualisation.oci-containers.backend = "docker";
        virtualisation.oci-containers.containers."cfddns" = {
          image = "ghcr.io/l480/cloudflare-dyndns:latest";

          ports = [
            "${toString cfddnsPreferences.reverseProxy.port}:80"
          ];

          extraOptions = [
            "--pull=always"
            "--name=cfddns"
          ];
        };
      };
    };
}
