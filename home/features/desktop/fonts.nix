{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.fonts;
in {

  options.features.desktop.fonts.enable = mkEnableOption "enable advanced fonts";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      font-manager
      font-awesome_5
      noto-fonts
    ];
  };

}