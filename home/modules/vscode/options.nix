{ lib, ... }:
{
  options.userPrefs.vscode.enable = lib.mkEnableOption "Enable VSCode";
}
