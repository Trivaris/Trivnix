{
  flake.nixosModules.networking-openconnect =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      ocClientPrefs = config.hostPrefs.openconnectClient;
      commonSecrets = "${osConfig.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf ocClientPrefs.enable {
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
