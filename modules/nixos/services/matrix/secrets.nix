{
  flake.nixosModules.services-matrix =
    {
      lib,
      config,
      ...
    }:
    let
      matrixPreferences = config.host.preferences.matrix;
    in
    {
      config.sops.secrets = lib.mkIf matrixPreferences.enable {
        matrix-secrets = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "root";
          group = "root";
        };
      };
    };
}
