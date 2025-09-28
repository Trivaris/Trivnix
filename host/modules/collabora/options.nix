{
  mkEnableOption,
  mkOption,
  mkReverseProxyOption,
  optionalString,
  prefs,
  types,
}:
{
  reverseProxy = mkReverseProxyOption { defaultPort = 9980; };

  enable = mkEnableOption ''
    Run the Forgejo git hosting service locally.
    Enable to provide a self-hosted Forgejo instance behind the reverse proxy.
  '';

  nextcloudFQDNs = mkOption {
    type = types.nullOr (types.listOf types.str);
    default = [
      optionalString
      prefs.nextcloud.enable
      prefs.nextcloud.reverseProxy.domain
    ];

    example = "nextcloud.example.com";
    description = ''
      The FQDN of your nextcloud server, defaults to this hosts' nextcloud instace, if its enabled.
      Set to null if you do not want to use this service with nextcloud.
    '';
  };
}
