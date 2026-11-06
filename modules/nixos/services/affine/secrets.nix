{
  flake.nixosModules.services-affine =
    {
      config,
      lib,
      ...
    }:
    let
      affine-prefs = config.host-prefs.affine;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf affine-prefs.enable {
        affine-db-password-env = {
          sopsFile = host-secrets;
          owner = "affine";
          group = "affine";
        };

        affine-postgres-password-env = {
          sopsFile = host-secrets;
          owner = "affine";
          group = "affine";
        };

        mail-affine-password = {
          sopsFile = host-secrets;
          owner = "affine";
          group = "affine";
        };
      };
    };
}
