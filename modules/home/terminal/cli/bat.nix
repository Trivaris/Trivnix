{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cli-prefs = config.user-prefs.cli;
    in
    {
      config = lib.mkIf cli-prefs.enable {
        programs.bat = {
          enable = true;
        };
      };
    };
}
