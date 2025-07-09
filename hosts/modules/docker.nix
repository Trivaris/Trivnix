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

  options.nixosModules.docker = mkEnableOption "Docker";

  config = mkIf cfg.docker {
    virtualisation.docker.enable = true;

  };

}
