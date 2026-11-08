{
  flake.nixosModules.services-affine =
    {
      config,
      lib,
      ...
    }:
    let
      affinePreferences = config.host.preferences.affine;
    in
    {
      config.sops.secrets = lib.mkIf affinePreferences.enable {
        affine-db-password-env = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "affine";
          group = "affine";
        };

        affine-postgres-password-env = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "affine";
          group = "affine";
        };

        mail-affine-password = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "affine";
          group = "affine";
        };
      };
    };
}
