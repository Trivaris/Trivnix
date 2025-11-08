{ config, ... }:
{
  assertions = [
    {
      assertion =
        config.hostPrefs.displayManager == "autologin"
        -> config.home-manager.users.${config.hostPrefs.mainUser}.vars.desktopEnvironmentBinary != null;
      message = ''Autologin requires a desktop environment. Set userPrefs.desktopEnvironment to a module that sets vars.desktopEnvironmentBinary.'';
    }
  ];
}
