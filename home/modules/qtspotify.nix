{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.spotify.enable = mkEnableOption "Enable Spotify QT Client";

  config = mkIf cfg.spotify.enable {
    home.packages = with pkgs; [
      spotify-qt
    ];
  };
}