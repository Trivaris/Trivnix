{
  flake.nixosModules.services-n8n =
    {
      lib,
      config,
      ...
    }:
    let
      n8nPreferences = config.host.preferences.n8n;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf n8nPreferences.enable {
        n8n-runner-auth-token = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
