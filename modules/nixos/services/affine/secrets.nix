{
  flake.nixosModules.services-affine =
    {
      config,
      lib,
      ...
    }:
    let
      affinePreferences = config.host.preferences.affine;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf affinePreferences.enable {
        affine-db-password-env = {
          sopsFile = hostSecrets;
          owner = "affine";
          group = "affine";
        };

        affine-postgres-password-env = {
          sopsFile = hostSecrets;
          owner = "affine";
          group = "affine";
        };

        mail-affine-password = {
          sopsFile = hostSecrets;
          owner = "affine";
          group = "affine";
        };
      };
    };
}
