{
  flake.nixosModules.services-n8n =
    {
      lib,
      config,
      ...
    }:
    let
      n8n-prefs = config.host-prefs.n8n;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf n8n-prefs.enable {
        n8n-runner-auth-token = {
          sopsFile = host-secrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
