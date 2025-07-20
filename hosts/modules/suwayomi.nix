{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules;
  dataDir = "/var/lib/suwayomi";
in
with lib;
{
  options.nixosModules.suwayomi = {
    enable = mkEnableOption "suwayomi";

    port = mkOption {
      type = types.int;
      default = 8890;
      description = "Internal port used by the reverse proxy.";
    };

    domain = mkOption {
      type = types.str;
      description = "DNS name used for external access.";
    };
  };

  config = mkIf cfg.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;
      dataDir = dataDir;

      settings.server = {
        host = "127.0.0.1";
        port = cfg.suwayomi.port;

        systemTrayEnabled = false;
        downloadAsCbz = true;
        extensionsRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];

        basicAuthEnabled = true;
        basicAuthUsername = "trivaris";
        basicAuthPasswordFile = config.sops.secrets.suwayomi-webui-password.path;
      };
    };

  };
}
