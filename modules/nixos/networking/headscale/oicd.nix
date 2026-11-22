{
  flake.nixosModules.networking-headscale = { lib, config, ... }:
  let 
    oicdPreferences = config.host.preferences.oicd;
  in 
  {
    services.pocket-id = lib.mkIf oicdPreferences.enable {
      enable = true;
      clientId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Pocket ID client ID; OIDC stays off in Headscale/Headplane until set";
      };
      settings = {
        APP_URL = "https://${oicdPreferences.reverseProxy.domain}";
        TRUST_PROXY = oicdPreferences.reverseProxy.enable;
        PORT = oicdPreferences.reverseProxy.port;
      };
    };
  };
}