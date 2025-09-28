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
  options.hostPrefs.collabora = import ./options.nix {
    inherit (lib)
      mkEnableOption
      mkOption
      optionalString
      types
      ;

    inherit (trivnixLib) mkReverseProxyOption;
    inherit prefs;
  };

  config = mkIf prefs.collabora.enable {
    services.collabora-online = {
      inherit (prefs.collabora.reverseProxy) port;
      enable = true;
      settings =
        let
          rPEnabled = prefs.collabora.reverseProxy.enable;
        in
        {
          server_name = prefs.collabora.reverseProxy.domain;

          ssl = {
            enable = !rPEnabled;
            termination = rPEnabled;
          };

          net = {
            listen = prefs.collabora.reverseProxy.ipAddress;
            post_allow.host = [ prefs.collabora.reverseProxy.ipAddress ];
          };

          storage.wopi = mkIf (prefs.collabora.nextcloudFQDNs != null) {
            "@allow" = true;
            host = prefs.collabora.nextcloudFQDNs;
          };
        };
    };
  };
}
