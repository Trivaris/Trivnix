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
  config = mkIf (builtins.elem "chatgpt" prefs.gui) {
    home.packages = [ pkgs.chatgpt ];
  };
}
