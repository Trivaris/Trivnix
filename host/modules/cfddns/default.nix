{
  config,
  lib,
  ...
}:
let
  cfddnsPrefs = config.hostPrefs.cfddns;
in
{
  config = lib.mkIf cfddnsPrefs.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers."cfddns" = {
      image = "ghcr.io/l480/cloudflare-dyndns:latest";

      ports = [
        "${toString cfddnsPrefs.reverseProxy.port}:80"
      ];

      extraOptions = [
        "--pull=always"
        "--name=cfddns"
      ];
    };
  };
}
