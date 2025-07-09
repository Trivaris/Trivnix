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

  options.nixosModules.sunshine = mkEnableOption "Sunshine";

  config = mkIf cfg.sunshine {
    environment.systemPackages = with pkgs; [ sunshine ];
    services.sunshine.enable = true;
  };

}
