{
  config,
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.suwayomi = import ./config.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;
      settings.server = {
        inherit (prefs.suwayomi.reverseProxy) port;
        host = prefs.suwayomi.reverseProxy.ipAddress;
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
