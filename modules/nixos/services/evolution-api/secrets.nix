{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      config,
      ...
    }:
    let
      evolution-prefs = config.host-prefs.evolution;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf evolution-prefs.enable {
        evolution-api-env = {
          sopsFile = host-secrets;
          owner = "evolution-api";
          group = "evolution-api";
        };
        evolution-api-postgres-env = {
          sopsFile = host-secrets;
          owner = "evolution-api";
          group = "evolution-api";
        };
      };
    };
}
