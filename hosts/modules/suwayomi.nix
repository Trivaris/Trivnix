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

  options.nixosModules.suwayomi = mkEnableOption "suwayomi";

  config = mkIf cfg.suwayomi {
    services.suwayomi-server = {
      enable = true;

      dataDir = "/var/lib/suwayomi";
      openFirewall = true;

      settings = {
        server.port = 4567;
      };
    };
  };

}
