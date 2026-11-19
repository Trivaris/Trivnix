{
  flake.nixosModules.networking-openconnect =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ocPreferences = config.host.preferences.openconnect;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf ocPreferences.enable {
        systemd.services.openconnect-openconnect0 = {
          path = [ pkgs.oath-toolkit ];
          wantedBy = lib.mkForce [ ];
          serviceConfig.ExecStart =
            let
              startCommand = lib.concatStringsSep " " [
                (toString (lib.getExe pkgs.openconnect))
                "--protocol=anyconnect"
                "--user=\"${ocPreferences.user}\""
                (lib.optionalString ocPreferences.authGroup != null "--authgroup=${ocPreferences.authGroup}")
                "--passwd-on-stdin"
                ocPreferences.gateway
              ];
            in
            lib.mkForce (
              pkgs.writeScript "openconnect-start" ''
                #!${lib.getExe pkgs.bash}

                PASS=$(cat ${secrets.openconnect-vpn-password.path})
                OTP_SECRET=$(cat ${secrets.openconnect-vpn-otp-secret.path})

                OTP_CODE=$(oathtool --totp -b "$OTP_SECRET")

                printf "%s\n%s\n" "$PASS" "$OTP_CODE" | \
                ${startCommand}
              ''
            );
        };

        networking.openconnect = {
          interfaces.openconnect0 = {
            inherit (ocPreferences) gateway user;
            protocol = "anyconnect";
            passwordFile = secrets.openconnect-vpn-password.path;
            extraOptions = {
              authgroup = lib.mkIf (ocPreferences.authGroup != null) ocPreferences.authGroup;
              cafile = lib.mkIf (ocPreferences.caFile != null) (toString ocPreferences.caFile);
            };
          };
        };
      };
    };
}
