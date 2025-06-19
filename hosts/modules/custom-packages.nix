{
  pkgs,
  config,
  lib,
  architecture,
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
      rmatrix
      rbonsai
      adbautoplayer
    ];
  };

}
