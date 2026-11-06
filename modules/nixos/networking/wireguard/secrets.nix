{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wireguard-prefs = config.host-prefs.wireguard;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf wireguard-prefs.enable {
        wireguard-key = {
          sopsFile = host-secrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
