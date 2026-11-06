{
  flake.homeModules.accounts-email =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      common-secrets = "${osConfig.private.secrets}/home/${config.user-infos.name}/common.yaml";
    in
    {
      config.sops.secrets = lib.pipe config.vars.filtered-email-accounts [
        builtins.attrNames
        (map (
          account:
          lib.nameValuePair "email-passwords/${account}" {
            sopsFile = common-secrets;
          }
        ))
        builtins.listToAttrs
      ];
    };
}
