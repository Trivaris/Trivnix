{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.fastfetch;
in {

  options.features.cli.fastfetch.enable = mkEnableOption "enable fastfetch";

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
  
}