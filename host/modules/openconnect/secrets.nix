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
  };
}