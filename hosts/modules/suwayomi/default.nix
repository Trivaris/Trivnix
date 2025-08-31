{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.suwayomi = import ./config.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf cfg.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;

      settings.server = {
        host = cfg.suwayomi.reverseProxy.ipAddress;
        port = cfg.suwayomi.reverseProxy.port;

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
