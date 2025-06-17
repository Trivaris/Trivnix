{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules;
in
with lib;
{

  options.homeModules.font = mkEnableOption "fonts";

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
