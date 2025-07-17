{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.docker.enable = mkEnableOption "Docker";

  config = mkIf cfg.docker.enable {
    virtualisation.docker.enable = true;

  };

}
