{
  flake.nixosModules.services-collabora =
    { lib, ... }:
    {
      options.host.preferences.collabora = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Collabora Online for browser-based document editing";

        nextcloudFQDNs = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          example = [ "nextcloud.example.com" ];
          description = ''
            Fully qualified domain names of Nextcloud instances allowed to use this
            Collabora Online service. Set to null when Nextcloud integration is not used.
          '';
        };
      };
    };
}
