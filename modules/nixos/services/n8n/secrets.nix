{
  flake.nixosModules.services-n8n =
    {
      lib,
      config,
      ...
    }:
    let
      n8nPreferences = config.host.preferences.n8n;
    in
    {
      config.sops.secrets = lib.mkIf n8nPreferences.enable {
        n8n-runner-auth-token = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = "root";
          group = "root";
        };
      };
    };
}
