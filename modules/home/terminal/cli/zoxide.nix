{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cli-prefs = config.user-prefs.cli;
    in
    {
      config = lib.mkIf cli-prefs.enable {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    };
}
