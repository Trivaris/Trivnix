{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      config,
      ...
    }:
    let
      evolutionPreferences = config.host.preferences.evolution;
    in
    {
      config.sops.secrets = lib.mkIf evolutionPreferences.enable {
        evolution-api-env = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "evolution-api";
          group = "evolution-api";
        };
        evolution-api-postgres-env = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "evolution-api";
          group = "evolution-api";
        };
      };
    };
}
