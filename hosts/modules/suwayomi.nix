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

  options.nixosModules.suwayomi = mkEnableOption "suwayomi";

  config = mkIf cfg.suwayomi {
    services.suwayomi-server = {
      enable = true;

      inherit dataDir;
      openFirewall = true;

      settings = {
        server.port = 4567;
        server.systemTrayEnabled = false;
        server.initialOpenInBrowserEnable = false;
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
