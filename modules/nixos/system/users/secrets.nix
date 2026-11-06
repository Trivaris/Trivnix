{
  flake.nixosModules.system-users =
    {
      lib,
      config,
      ...
    }:
    let
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
      normalUsers = lib.filterAttrs (name: userCfg: userCfg.isNormalUser) config.users.users;
    in
    {
      sops.secrets = lib.mapAttrs' (
        username: userconfig:
        lib.nameValuePair "sops-keys/${username}" {
          sopsFile = host-secrets;

          path = "${userconfig.home}/.config/sops/age/key.txt";
          owner = username;
        }
      ) normalUsers;
    };
}
