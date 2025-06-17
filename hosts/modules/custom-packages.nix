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

  options.nixosModules.custom-packages = mkEnableOption "Custom Packages";

  config = mkIf cfg.custom-packages {
    environment.systemPackages = with pkgs; [
      r-matrix
      rbonsai
    ];
  };

}
