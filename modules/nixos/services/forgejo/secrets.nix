{
  flake.nixosModules.services-forgejo =
    {
      lib,
      config,
      ...
    }:
    let
      forgejoPreferences = config.host.preferences.forgejo;
    in
    {
      config.sops.secrets = lib.mkIf forgejoPreferences.enable {
        mail-forgejo-password = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "forgejo";
          group = "forgejo";
        };
      };
    };
}
