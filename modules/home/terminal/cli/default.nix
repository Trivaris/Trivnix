{
  flake.homeModules.terminal-cli =
    { lib, ... }:
    {
      options.user.preferences.cli.enable =
        lib.mkEnableOption "Replacement of selected default CLI utilities with the configured alternatives";
    };
}
