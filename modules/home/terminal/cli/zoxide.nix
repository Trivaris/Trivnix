{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cliPreferences = config.user.preferences.cli;
    in
    {
      config = lib.mkIf cliPreferences.enable {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    };
}
