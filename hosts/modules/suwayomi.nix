  {
  config,
  lib,
  pkgs,
  ...
}:
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
      description = "Internal Port used by the reverse Proxy";
    };

    domain = mkOption {
      type = types.str;
      description = "DNS name";
    };
  };

  config = mkIf cfg.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;
      inherit dataDir;
      openFirewall = true;

      settings.server = {
        port = cfg.suwayomi.port;
        systemTrayEnabled = false;
        initialOpenInBrowserEnable = false;
      };
    };

    systemd.services.suwayomi-webui = {
      description = "Unpack and inject WebUI for Suwayomi";
      after = [ "network.target" ];
      before = [ "suwayomi-server.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "suwayomi-webui-copy" ''
          set -euo pipefail

          src="${pkgs.suwayomi-server}/lib/webUI"
          dst="${dataDir}/.local/share/Tachidesk/webUI"

          rm -rf "$dst"
          mkdir -p "$(dirname "$dst")"
          cp -r "$src" "$dst"
        '';
      };
    };

    systemd.services.suwayomi-server = {
      after = [ "suwayomi-webui.service" ];
    };
  };
}
