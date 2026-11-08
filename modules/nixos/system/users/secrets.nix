{
  flake.nixosModules.system-users =
    {
      lib,
      config,
      ...
    }:
    let
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
      commonSecrets = "${config.private.secrets}/host/common.yaml";
      normalUsers = lib.filterAttrs (name: userCfg: userCfg.isNormalUser) config.users.users;
    in
    {
      sops.secrets = lib.pipe normalUsers [
        (lib.mapAttrsToList (
          username: userconfig: [
            (lib.nameValuePair "sops-keys/${username}" {
              sopsFile = hostSecrets;

              path = "${userconfig.home}/.config/sops/age/key.txt";
              owner = username;
            })
            (lib.nameValuePair "hashed-passwords/${username}" {
              sopsFile = commonSecrets;
              owner = username;
            })
          ]
        ))
        lib.flatten
        builtins.listToAttrs
      ];
    };
}
