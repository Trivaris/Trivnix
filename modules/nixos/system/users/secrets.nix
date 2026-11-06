{
  flake.nixosModules.system-users =
    {
      lib,
      config,
      ...
    }:
    let
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
      allUserInfos = builtins.mapAttrs (_: cfg: cfg.user-infos) config.home-manager.users;
    in
    {
      config.sops.secrets = lib.mapAttrs' (
        user: _:
        lib.nameValuePair "sops-keys/${user}" {
          sopsFile = host-secrets;
          path = "/home/${user}/.config/sops/age/key.txt";
          owner = user;
        }
      ) (lib.filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));
    };
}
