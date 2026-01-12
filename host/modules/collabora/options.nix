{
  lib,
  trivnixLib,
  ...
}:
{
  options.hostPrefs.collabora = {
    reverseProxy = trivnixLib.mkReverseProxyOption { defaultPort = 9980; };

    enable = lib.mkEnableOption ''
      Run the Forgejo git hosting service locally.
      Enable to provide a self-hosted Forgejo instance behind the reverse proxy.
    '';

    nextcloudFQDNs = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      example = "nextcloud.example.com";
      description = ''
        The FQDN of your nextcloud server.
        Set to null if you do not want to use this service with nextcloud.
      '';
    };
  };
}
