{
  flake.nixosModules.networking-openconnect =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      openconnect-prefs = config.host-prefs.openconnect;
      common-secrets = "${osConfig.private.secrets}/host/common.yaml";
    in
    {
      config.sops.secrets = lib.mkIf openconnect-prefs.enable {
        openconnect-vpn-password = {
          sopsFile = common-secrets;
          owner = "root";
          group = "root";
        };
        openconnect-vpn-otp-secret = {
          sopsFile = common-secrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
