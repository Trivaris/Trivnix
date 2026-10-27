{ lib, ... }:
{
  options.hostPrefs.collabora = {
    reverseProxy = lib.mkReverseProxyOption;

    enable = lib.mkEnableOption ''
      Collabora Online for browser-based document editing.
      It is exposed through the configured reverse proxy.
    '';

    nextcloudFQDNs = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      example = [ "nextcloud.example.com" ];
      description = ''
        Fully qualified domain names of Nextcloud instances allowed to use this
        Collabora Online service. Set to null when Nextcloud integration is not used.
      '';
    };
  };
}
