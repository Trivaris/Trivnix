{
  flake.nixosModules.services-matrix =
    {
      lib,
      config,
      ...
    }:
    let
      matrix-prefs = config.host-prefs.matrix;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf matrix-prefs.enable {
        matrix-secrets = {
          sopsFile = host-secrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
