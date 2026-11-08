{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      config,
      ...
    }:
    let
      evolutionPreferences = config.host.preferences.evolution;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf evolutionPreferences.enable {
        evolution-api-env = {
          sopsFile = hostSecrets;
          owner = "evolution-api";
          group = "evolution-api";
        };
        evolution-api-postgres-env = {
          sopsFile = hostSecrets;
          owner = "evolution-api";
          group = "evolution-api";
        };
      };
    };
}
