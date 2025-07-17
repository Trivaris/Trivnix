{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.fish.enable = mkEnableOption "Fish";

  config = mkIf cfg.fish.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };

}
