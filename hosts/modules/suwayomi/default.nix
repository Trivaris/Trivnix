{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.hostprefs;
in
{
  options.hostprefs.suwayomi = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

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
