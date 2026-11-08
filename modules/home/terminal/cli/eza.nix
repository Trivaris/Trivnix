{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cliPreferences = config.user.preferences.cli;
    in
    {
      config = lib.mkIf cliPreferences.enable {
        programs.eza = {
          enable = true;
          enableZshIntegration = true;
          extraOptions = [
            "-l"
            "--icons"
            "--git"
            "-a"
          ];
        };
      };
    };
}
