{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.enableDevStuffs = lib.mkEnableOption "Enable Dev Stuffs lol";
  config = lib.mkIf prefs.enableDevStuffs {
    home.packages = [ pkgs.gradle_9 ];
    programs = {
      java = {
        enable = true;
        package = pkgs.zulu21;
      };

      vscode.profiles.default.extensions = lib.mkIf prefs.vscode.enable [
        pkgs.vscode-extensions.redhat.java
        pkgs.vscode-extensions.vscjava.vscode-java-pack
      ];
    };
  };
}
