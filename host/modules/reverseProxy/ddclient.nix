{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.reverseProxy.enableDDClient {
    services.ddclient = {
      inherit (prefs.reverseProxy) zone;
      enable = true;
      protocol = "cloudflare";
      usev4 = "webv4,webv4=ipify-ipv4";
      usev6 = "webv6,webv6=ipify-ipv6";
      ssl = true;
      verbose = true;
      domains =
        (map (service: service.domain) config.vars.activeServices) ++ prefs.reverseProxy.extraDDNSDomains;
      username = "token";
      passwordFile = config.sops.secrets.cloudflare-api-account-token.path;
    };

    systemd.timers.ddclient = lib.mkIf (prefs.reverseProxy.ddnsTime != null) {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = prefs.reverseProxy.ddnsTime;
        Persistent = true;
      };
    };
  };
}
