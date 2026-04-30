{
  osConfig,
  config,
  lib,
  ...
}:
let
  syncthingPrefs = config.userPrefs.syncthing;
in
{
  options.userPrefs.syncthing.enable = lib.mkEnableOption "Syncthing, a file sync service";
  config = lib.mkIf syncthingPrefs.enable {
    services.syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
      tray.enable = true;
      settings.gui = {
        user = osConfig.hostPrefs.mainUser;
        authMode = "static";
        sendBasicAuthPrompt = true;
        insecureAdminAccess = false;
      };
    };
  };
}