{
  flake.nixosModules.networking-headscale = { config, lib, ... }:
  let
    hsPreferences = config.host.preferences.headscale;
    hpPreferences = config.host.preferences.headplane;
    oidcPreferences = config.host.preferences.oicd;
  in
  {
    sops.secrets = lib.mkMerge [
      (lib.mkIf hpPreferences.enable {
        headplane-cookie = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.services.headscale.user;
          group = config.services.headscale.group;
          mode = "0400";
        };
        headscale-api-key = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.services.headscale.user;
          group = config.services.headscale.group;
          mode = "0400";
        };
      })
      (lib.mkIf oidcPreferences.enable {
        pocket-id-encryption-key = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.services.pocket-id.user;
          group = config.services.pocket-id.group;
          mode = "0400";
        };
      })
      (lib.mkIf (hsPreferences.enable && oidcPreferences.enable && oidcPreferences.clientId != null) {
        headscale-oidc-secret = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.services.headscale.user;
          group = config.services.headscale.group;
          mode = "0400";
        };
      })
      (lib.mkIf (hpPreferences.enable && oidcPreferences.enable && oidcPreferences.clientId != null) {
        headplane-oidc-secret = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = config.services.headscale.user;
          group = config.services.headscale.group;
          mode = "0400";
        };
      })
    ];
  };
}
