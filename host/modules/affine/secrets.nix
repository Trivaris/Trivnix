{
  config,
  lib,
  ...
}:
let
  affinePrefs = config.hostPrefs.affine;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf affinePrefs.enable {
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
}