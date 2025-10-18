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
  options.hostPrefs.cfddns = import ./options.nix {
    inherit (lib) mkEnableOption;
    inherit (trivnixLib) mkReverseProxyOption;
  };

  config = mkIf prefs.cfddns.enable {
    services.cfddns = {
      inherit (prefs.cfddns.reverseProxy) port;
      enable = true;
    };
  };
}
