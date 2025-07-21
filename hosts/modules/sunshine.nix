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

  options.nixosModules.sunshine = {
    enable = mkEnableOption "Enable Sunshine remote desktop proxy integration.";

    hostMac = mkOption {
      type = types.str;
      example = "3C:52:82:4B:00:11";
      description = ''
        MAC address of the Sunshine desktop, used to send Wake-on-LAN packets.
      '';
    };

    hostIP = mkOption {
      type = types.str;
      example = "192.168.1.100";
      description = ''
        IPv4 address of the Sunshine desktop, used by the TCP/UDP proxy and for reachability checks.
      '';
    };
  };

  config = mkIf cfg.sunshine.enable {
    services.haproxy = {
      enable = true;
      config = ''
        frontend sunshine-ctrl
          bind *:47984
          mode tcp
          default_backend sunshine-ctrl-backend

        backend sunshine-ctrl-backend
          mode tcp
          server sunshine ${cfg.sunshine.hostIP}:47984

        frontend sunshine-stream
          bind *:47989
          mode tcp
          default_backend sunshine-stream-backend

        backend sunshine-stream-backend
          mode tcp
          server sunshine ${cfg.sunshine.hostIP}:47989

        frontend sunshine-web
          bind *:47990
          mode tcp
          default_backend sunshine-web-backend

        backend sunshine-web-backend
          mode tcp
          server sunshine ${cfg.sunshine.hostIP}:47990

        frontend sunshine-extra
          bind *:48010
          mode tcp
          default_backend sunshine-extra-backend

        backend sunshine-extra-backend
          mode tcp
          server sunshine ${cfg.sunshine.hostIP}:48010
        '';
    };

    networking.firewall = {
      allowedTCPPorts = [ 5353 47984 47989 47990 48010 ];
      allowedUDPPorts = [ 47998 47999 48000 48001 48002 48003 48004 48005 48006 48007 48008 48009 48010 ];
    };

    environment.etc."wake.sh".text = ''
      #!${pkgs.bash}/bin/bash
      MAC="${cfg.sunshine.hostMac}"
      IP="${cfg.sunshine.hostIP}"
      TARGET_PORT=47989  # Expected Sunshine HTTP/WebSocket API port
      TIMEOUT=60

      ${pkgs.wakeonlan}/bin/wakeonlan "$MAC"

      echo "Waiting for Sunshine at $IP:$TARGET_PORT..."
      for i in $(seq 1 $TIMEOUT); do
        if ${pkgs.netcat}/bin/nc -z "$IP" "$TARGET_PORT"; then
          echo "Redirecting to Sunshine..."
          exit 0
        fi
        sleep 1
      done

      echo "Timeout waiting for Sunshine"
      exit 1
    '';

    environment.etc."udp-proxy.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        SUNSHINE_IP="${cfg.sunshine.hostIP}"

        for PORT in {47998..48010}; do
          echo "Starting UDP proxy for port $PORT to $SUNSHINE_IP"
          ${pkgs.socat}/bin/socat \
            UDP4-RECVFROM:$PORT,fork,reuseaddr \
            UDP4-SENDTO:$SUNSHINE_IP:$PORT &
        done

        wait
      '';
      mode = "0755";
    };


    systemd.services.sunshine-udp-proxy = {
      description = "UDP Proxy for Sunshine (WAN-safe)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/etc/udp-proxy.sh";
        Restart = "always";
        RestartSec = 2;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.services.sunshine-wake-http = {
      description = "Wake-on-LAN and Redirect HTTP Service for Sunshine";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nmap}/bin/ncat -klp 5353 --sh-exec /etc/wake.sh";
        Restart = "on-failure";
        RestartSec = 5;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };

}
