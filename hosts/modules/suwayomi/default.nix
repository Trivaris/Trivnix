{ config, lib, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.suwayomi = import ./config.nix lib;

  config = mkIf cfg.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;

      settings.server = {
        host = cfg.suwayomi.ipAddress;
        port = cfg.suwayomi.port;

        systemTrayEnabled = false;
        downloadAsCbz = true;
        extensionsRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];

        basicAuthEnabled = true;
        basicAuthUsername = "admin";
        basicAuthPasswordFile = config.sops.secrets.suwayomi-webui-password.path;
      };
    };
  };
}
