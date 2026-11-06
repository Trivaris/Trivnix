{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cli-prefs = config.user-prefs.cli;
    in
    {
      config = lib.mkIf cli-prefs.enable {
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
