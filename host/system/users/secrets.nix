{
  lib,
  config,
  ...
}:
let 
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
  allUserInfos = builtins.mapAttrs (_: cfg: cfg.userInfos) config.home-manager.users;
in
{
  config.sops.secrets = lib.mapAttrs' (
    user: _:
    lib.nameValuePair "sops-keys/${user}" {
      sopsFile = hostSecrets;
      path = "/home/${user}/.config/sops/age/key.txt";
      owner = user;
      group = "users";
    }
  ) (lib.filterAttrs (user: _: user != "root") (allUserInfos // { root = { }; }));
}