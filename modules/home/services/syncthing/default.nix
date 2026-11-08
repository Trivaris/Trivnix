{
  flake.homeModules.services-syncthing =
    {
      osConfig,
      config,
      lib,
      ...
    }:
    let
      syncthingPreferences = config.user.preferences.syncthing;
    in
    {
      options.user.preferences.syncthing.enable =
        lib.mkEnableOption "Syncthing, a file synchronization service";
      config = lib.mkIf syncthingPreferences.enable {
        services.syncthing = {
          enable = true;
          guiAddress = "127.0.0.1:8384";
          overrideDevices = false;
          overrideFolders = false;
          settings.gui = {
            user = config.home.username;
            authMode = "static";
            sendBasicAuthPrompt = true;
            insecureAdminAccess = false;
          };
        };
      };
    };
}
