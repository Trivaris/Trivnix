{
  flake.nixosModules.networking-openconnect =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ocClientPreferences = config.host.preferences.openconnect;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf ocClientPreferences.enable {
        systemd.services.openconnect-openconnect0 = {
          path = [ pkgs.oath-toolkit ];
          wantedBy = lib.mkForce [ ];
          serviceConfig.ExecStart = lib.mkForce (
            pkgs.writeScript "openconnect-start" ''
              #!${lib.getExe pkgs.bash}

              PASS=$(cat ${secrets.openconnect-vpn-password.path})
              OTP_SECRET=$(cat ${secrets.openconnect-vpn-otp-secret.path})

              OTP_CODE=$(oathtool --totp -b "$OTP_SECRET")

              printf "%s\n%s\n" "$PASS" "$OTP_CODE" | \
                ${lib.getExe pkgs.openconnect} \
                --protocol=anyconnect \
                --user="${ocClientPreferences.user}" \
                --authgroup="${ocClientPreferences.authGroup}" \
                --passwd-on-stdin \
                ${ocClientPreferences.gateway}
            ''
          );
        };

        networking.openconnect = {
          interfaces.openconnect0 = {
            inherit (ocClientPreferences) gateway user;
            protocol = "anyconnect";
            passwordFile = secrets.openconnect-vpn-password.path;
            extraOptions = {
              authgroup = lib.mkIf (ocClientPreferences.authGroup != null) ocClientPreferences.authGroup;
              cafile = lib.mkIf (ocClientPreferences.caFile != null) (toString ocClientPreferences.caFile);
            };
          };
        };
      };
    };
}
