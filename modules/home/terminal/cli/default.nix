{
  flake.homeModules.terminal-cli =
    { lib, ... }:
    {
      options.user-prefs.cli.enable = lib.mkEnableOption "Replacement of selected default CLI utilities with the configured alternatives";
    };
}
