{
  flake.nixosModules.services-matrix =
    {
      lib,
      config,
      ...
    }:
    let
      matrixPreferences = config.host.preferences.matrix;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf matrixPreferences.enable {
        matrix-secrets = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
