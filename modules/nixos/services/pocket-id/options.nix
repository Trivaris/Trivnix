{
  flake.nixosModules.services-pocket-id = { lib, ... }: {
    options.host.preferences.pocket-id = {
      enable = lib.mkEnableOption "OICD auth and service via pocket-id";
      reverseProxy = lib.trivnix.mkReverseProxyOption;
      clientId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Pocket ID client ID; OIDC stays off in Headscale/Headplane until set";
      };
    };
  };
}