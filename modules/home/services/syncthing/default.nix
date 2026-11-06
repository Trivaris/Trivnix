{
  flake.homeModules.services-syncthing =
    {
      osConfig,
      config,
      lib,
      ...
    }:
    let
      syncthing-prefs = config.user-prefs.syncthing;
    in
    {
      options.user-prefs.syncthing.enable = lib.mkEnableOption "Syncthing, a file synchronization service";
      config = lib.mkIf syncthing-prefs.enable {
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
