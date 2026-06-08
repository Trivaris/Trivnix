{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfddnsPrefs = config.hostPrefs.cfddns;
in
{
  config = lib.mkIf cfddnsPrefs.enable {
    systemd.services.cfddns = {
      description = "Cloudflare Dyn DNS Middleware Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.cfddns-middleware} --port ${toString cfddnsPrefs.reverseProxy.port}";
        Restart = "on-failure";
      };
    };
  };
}
