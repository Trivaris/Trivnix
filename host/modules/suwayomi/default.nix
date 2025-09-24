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
  options.hostPrefs.suwayomi = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.suwayomi.enable {
    services.suwayomi-server = {
      enable = true;
      settings.server = {
        inherit (prefs.suwayomi.reverseProxy) port;
        host = prefs.suwayomi.reverseProxy.ipAddress;
        openFireWall = !prefs.suwayomi.reverseProxy.enable;
        systemTrayEnabled = false;
        downloadAsCbz = true;
        extensionsRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
        basicAuthEnabled = true;
        basicAuthUsername = prefs.mainUser;
        basicAuthPasswordFile = config.sops.secrets.suwayomi-webui-password.path;
      };
    };
  };
}
