{
  lib,
  config,
  ...
}:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.btop.enable = mkEnableOption "Extended Btop Configuration";

  config = mkIf cfg.btop.enable {
    programs.btop.enable = true;
  };
}