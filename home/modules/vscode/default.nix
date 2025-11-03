{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.userPrefs.vscode.enable {
    home.packages = [
      pkgs.vscode
    ];
  };
}
