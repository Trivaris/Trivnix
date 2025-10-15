{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.userPrefs;
in
{
  options.userPrefs.enableDevStuffs = mkEnableOption "Enable Dev Stuffs lol";
  config = mkIf prefs.enableDevStuffs {
    home.packages = [ pkgs.gradle_9 ];
    programs = {
      java = {
        enable = true;
        package = pkgs.zulu21;
      };

      vscode.profiles.default.extensions = mkIf prefs.vscode.enable [
        pkgs.vscode-extensions.redhat.java
        pkgs.vscode-extensions.vscjava.vscode-java-pack
      ];
    };
  };
}
