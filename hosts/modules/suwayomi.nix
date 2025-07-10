  {
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.suwayomi = mkEnableOption "suwayomi";

  config = mkIf cfg.suwayomi {
    services.suwayomi-server = {
      enable = true;
      package = pkgs.suwayomi-server-update;

      dataDir = "/var/lib/suwayomi";
      openFirewall = true;

      settings = {
        server.port = 4567;
        server.systemTrayEnabled = false;
        server.initialOpenInBrowserEnable = false;
      };
    };
  };

}
