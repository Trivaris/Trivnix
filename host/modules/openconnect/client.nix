{
  config,
  lib,
  ...
}:
let
  ocClientPrefs = config.hostPrefs.openconnectClient;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf ocClientPrefs.enable {
    systemd.services.openconnect-openconnect0.wantedBy = lib.mkForce [ ];
    networking.openconnect = {
      interfaces.openconnect0 = {
        inherit (ocClientPrefs) gateway user;
        protocol = "anyconnect";
        passwordFile = secrets.openconnect-vpn-password.path;
        extraOptions = {
          authgroup = lib.mkIf (ocClientPrefs.authgroup != null) ocClientPrefs.authgroup;
          cafile = lib.mkIf (ocClientPrefs.cafile != null) (
            toString ocClientPrefs.cafile
          );
        };
      };
    };
  };
}
