{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  name = "zoxide";
  isShell = shell: prefs.shell == shell;
in
{
  config = mkIf (builtins.elem name prefs.cli.enabled) {
    vars.cliReplacements = [ name ];
    programs.zoxide = {
      enable = true;
      enableFishIntegration = isShell "fish";
      enableBashIntegration = isShell "bash";
      enableZshIntegration = isShell "zsh";
    };
  };
}
