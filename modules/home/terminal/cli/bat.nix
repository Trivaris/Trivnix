{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cliPreferences = config.user.preferences.cli;
    in
    {
      config = lib.mkIf cliPreferences.enable {
        programs.bat = {
          enable = true;
        };
      };
    };
}
