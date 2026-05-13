{
  config,
  lib,
  pkgs,
  ...
}:
let
  ocClientPrefs = config.hostPrefs.openconnectClient;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf ocClientPrefs.enable {
    systemd.services.openconnect-openconnect0 = {
      path = [ pkgs.oath-toolkit ];
      wantedBy = lib.mkForce [ ];
      serviceConfig.ExecStart = lib.mkForce (pkgs.writeScript "openconnect-start" ''
        #!${lib.getExe pkgs.bash}

        PASS=$(cat ${secrets.openconnect-vpn-password.path})
        OTP_SECRET=$(cat ${secrets.openconnect-vpn-otp-secret.path})
        
        OTP_CODE=$(oathtool --totp -b "$OTP_SECRET")

        printf "%s\n%s\n" "$PASS" "$OTP_CODE" | \
          ${lib.getExe pkgs.openconnect} \
          --protocol=anyconnect \
          --user="${ocClientPrefs.user}" \
          --authgroup="${ocClientPrefs.authgroup}" \
          --passwd-on-stdin \
          ${ocClientPrefs.gateway}
      '');
    };

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
