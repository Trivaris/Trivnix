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

  options.nixosModules.fish = mkEnableOption "Fish";

  config = mkIf cfg.fish {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };

}
