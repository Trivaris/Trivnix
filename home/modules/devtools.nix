{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      zulu21
      gradle_9
      ;
  };

  programs.vscode.profiles.default.extensions = mkIf prefs.vscode.enable [
    pkgs.vscode-extensions.redhat.java
    pkgs.vscode-extensions.vscjava.vscode-java-pack
  ];
}
