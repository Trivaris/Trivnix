{
  flake.nixosModules.networking-openconnect =
    {
      lib,
      config,
      ...
    }:
    let
      openconnectPreferences = config.host.preferences.openconnect;
    in
    {
      config.sops.secrets = lib.mkIf openconnectPreferences.enable {
        openconnect-vpn-password = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "root";
          group = "root";
        };
        openconnect-vpn-otp-secret = {
          sopsFile = config.host.private.secrets.commonSecretsFile;
          owner = "root";
          group = "root";
        };
      };
    };
}
