{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.bitwarden.enable = mkEnableOption "Enable Bitwarden Desktop Client";

  config = mkIf cfg.bitwarden.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
