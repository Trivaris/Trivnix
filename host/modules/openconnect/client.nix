{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.openconnectClient.enable {
    systemd.services.openconnect-openconnect0.wantedBy = lib.mkForce [ ];
    networking.openconnect = {
      interfaces.openconnect0 = {
        inherit (prefs.openconnectClient) gateway user;
        protocol = "anyconnect";
        passwordFile = config.sops.secrets.openconnect-vpn-password.path;
        extraOptions = {
          authgroup = lib.mkIf (prefs.openconnectClient.authgroup != null) prefs.openconnectClient.authgroup;
          cafile = lib.mkIf (prefs.openconnectClient.cafile != null) (
            toString prefs.openconnectClient.cafile
          );
        };
      };
    };
  };
}
