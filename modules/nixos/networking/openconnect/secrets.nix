{
  flake.nixosModules.networking-openconnect =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      openconnectPreferences = config.host.preferences.openconnect;
      commonSecrets = "${osConfig.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf openconnectPreferences.enable {
        openconnect-vpn-password = {
          sopsFile = commonSecrets;
          owner = "root";
          group = "root";
        };
        openconnect-vpn-otp-secret = {
          sopsFile = commonSecrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
