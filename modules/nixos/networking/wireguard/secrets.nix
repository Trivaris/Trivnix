{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wireguardPreferences = config.host.preferences.wireguard;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf wireguardPreferences.enable {
        wireguard-key = {
          sopsFile = hostSecrets;
          owner = "root";
          group = "root";
        };
      };
    };
}
