{
  flake.nixosModules.services-pocket-id = { config, lib, ... }:
  let 
    piPreferences = config.host.preferences.pocket-id;
  in {
    sops.secrets.pocket-id-encryption-key = lib.mkIf piPreferences.enable {
      sopsFile = config.host.private.secrets.hostSecretsFile;
      owner = config.services.pocket-id.user;
      group = config.services.pocket-id.group;
      mode = "0400";
    };
  };
}