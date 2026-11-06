{
  flake.nixosModules.services-paperless =
    {
      config,
      lib,
      ...
    }:
    let
      paperless-prefs = config.host-prefs.paperless;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf paperless-prefs.enable {
        paperless-admin-password = {
          sopsFile = host-secrets;
          owner = "paperless";
          group = "paperless";
        };
      };
    };
}
