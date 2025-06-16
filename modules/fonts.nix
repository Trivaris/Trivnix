{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules;
in
with lib;
{

  options.modules.font = mkEnableOption "fonts";

  config = mkIf cfg.font {
    home.packages = with pkgs; [
      fira-code-symbols
      nerd-fonts.fira-code
      font-manager
      font-awesome_5
      noto-fonts
    ];
  };

}
