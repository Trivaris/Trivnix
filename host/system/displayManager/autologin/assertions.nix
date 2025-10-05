{ config, prefs }:
[
  {
    assertion = config.home-manager.users.${prefs.mainUser}.vars.desktopEnvironmentBinary != null;
    message = ''Autologin requires a desktop environment. Set userPrefs.desktopEnvironment to a module that sets vars.desktopEnvironmentBinary.'';
  }
]
