{
  flake.nixosModules.services-pocket-id = { lib, config, ... }:
  let 
    piPreferences = config.host.preferences.pocket-id;
  in 
  {
    services.pocket-id = lib.mkIf piPreferences.enable {
      enable = true;
      settings = {
        APP_URL = "https://${piPreferences.reverseProxy.domain}";
        TRUST_PROXY = piPreferences.reverseProxy.enable;
        PORT = piPreferences.reverseProxy.port;
        ENCRYPTION_KEY_FILE = config.sops.secrets.pocket-id-encryption-key.path;
      };
    };
  };
}
