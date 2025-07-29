{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.spotify.enable = mkEnableOption "Enable Spotify Client";

  config = mkIf cfg.spotify.enable {
    programs.spicetify = {
      enable = true;
    };
  };
}