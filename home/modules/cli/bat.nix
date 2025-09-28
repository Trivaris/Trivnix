{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  name = "bat";
in
{
  config = mkIf (builtins.elem name prefs.cli.enabled) {
    vars.cliReplacements = [ name ];
    programs.bat.enable = true;
  };
}
