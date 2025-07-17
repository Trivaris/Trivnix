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

  options.nixosModules.greet.enable = mkEnableOption "TUI Greeter";

  config = mkIf cfg.greet.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd exec start-kde";
          user = "trivaris";
        };
      };
    };
  };

}
