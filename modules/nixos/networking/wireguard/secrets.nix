{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wgPrefs = config.host.preferences.wireguard;
    in
    {
      config.sops.secrets = lib.mkIf wgPrefs.enable {
        wireguard-key = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          owner = "root";
          group = "root";
        };
      };
    };
}
