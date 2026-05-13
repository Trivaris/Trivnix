{
  lib,
  config,
  ...
}:
let 
  ocClientPrefs = config.hostPrefs.openconnectClient;
in
{
  config.sops.secrets = lib.mkIf ocClientPrefs.enable {
    openconnect-vpn-password = {
      owner = "root";
      group = "root";
    };
    openconnect-vpn-otp-secret = {
      owner = "root";
      group = "root";
    };
  };
}