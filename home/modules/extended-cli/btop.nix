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
  config = mkIf (builtins.elem "btop" cfg.extendedCli) {
    programs.btop.enable = true;
  };
}