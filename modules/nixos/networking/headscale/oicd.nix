{
  flake.nixosModules.networking-headscale = { lib, config, ... }:
  let 
    oicdPreferences = config.host.preferences.oicd;
  in 
  {
    services.pocket-id = lib.mkIf oicdPreferences.enable {
      enable = true;
      settings = {
        APP_URL = "https://${oicdPreferences.reverseProxy.domain}";
        TRUST_PROXY = oicdPreferences.reverseProxy.enable;
        PORT = oicdPreferences.reverseProxy.port;
        ENCRYPTION_KEY_FILE = config.sops.secrets.pocket-id-encryption-key.path;
      };
    };
  };
}
