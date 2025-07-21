{ pkgs, config, lib, ... }:
let
  cfg = config.nixosModules.font;
in
with lib;
{

  options.nixosModules.font = {
    enable = mkEnableOption "Enable system-wide font installation and configuration.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      font-manager
    ];

    fonts.packages = with pkgs; [
      fira-code-symbols
      nerd-fonts.fira-code
      font-awesome_5
      noto-fonts
    ];

    fonts.enableDefaultPackages = true;
    fonts.fontconfig.enable = true;
  };
}
