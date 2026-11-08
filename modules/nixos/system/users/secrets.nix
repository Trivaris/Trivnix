{
  flake.nixosModules.system-users =
    {
      lib,
      config,
      ...
    }:
    let
      normalUsers = lib.filterAttrs (name: userCfg: userCfg.isNormalUser) config.users.users;
    in
    {
      sops.secrets = lib.pipe normalUsers [
        (lib.mapAttrsToList (
          username: userconfig: [
            (lib.nameValuePair "sops-keys/${username}" {
              sopsFile = config.host.private.secrets.hostSecretsFile;

              path = "${userconfig.home}/.config/sops/age/key.txt";
              owner = username;
            })
            (lib.nameValuePair "hashed-passwords/${username}" {
              sopsFile = config.host.private.secrets.commonSecretsFile;
              owner = username;
            })
          ]
        ))
        lib.flatten
        builtins.listToAttrs
      ];
    };
}
