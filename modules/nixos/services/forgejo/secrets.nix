{
  flake.nixosModules.services-forgejo =
    {
      lib,
      config,
      ...
    }:
    let
      forgejoPreferences = config.host.preferences.forgejo;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf forgejoPreferences.enable {
        mail-forgejo-password = {
          sopsFile = hostSecrets;
          owner = "forgejo";
          group = "forgejo";
        };
      };
    };
}
