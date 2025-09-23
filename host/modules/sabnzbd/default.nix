{
  config,
  trivnixLib,
  # pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.sabnzbd = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.sabnzbd.enable {
    services.sabnzbd = {
      enable = true;
      openFirewall = true;
      /*
        configFile = pkgs.writeTextFile {
          name = "sabnzbd.ini";
          text = ''
            [misc]
            host = ${prefs.sabnzbd.reverseProxy.ipAddress}
            port = ${toString prefs.sabnzbd.reverseProxy.port}
            username = ${prefs.mainUser}
            password = ${builtins.readFile config.sops.secrets.sabnzbd-webui-password.path}
          '';
        };
      */
    };
  };
}
