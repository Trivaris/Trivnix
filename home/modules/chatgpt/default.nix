{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.chatgpt.enable = mkEnableOption "Enable ChatGPT Desktop";

  config = mkIf cfg.chatgpt.enable {
    home.packages = with pkgs; [
      chatgpt
    ];
  };
}
