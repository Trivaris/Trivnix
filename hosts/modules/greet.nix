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

  options.nixosModules.greet = mkEnableOption "TUI Greeter";

  config = mkIf cfg.greet {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd exec Hyprland";
          user = "trivaris";
        };
      };
    };
  };

}
