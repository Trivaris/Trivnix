{
  flake.nixosModules.services-forgejo =
    {
      lib,
      config,
      ...
    }:
    let
      forgejo-prefs = config.host-prefs.forgejo;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf forgejo-prefs.enable {
        mail-forgejo-password = {
          sopsFile = host-secrets;
          owner = "forgejo";
          group = "forgejo";
        };
      };
    };
}
