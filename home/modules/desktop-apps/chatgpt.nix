{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "chatgpt" cfg.desktopApps) {
    home.packages = with pkgs; [
      chatgpt
    ];
  };
}
