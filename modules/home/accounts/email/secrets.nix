{
  flake.homeModules.accounts-email =
    {
      lib,
      config,
      osConfig,
      ...
    }:
    let
      commonSecrets = "${osConfig.private.secrets}/home/${config.home.username}/common.yaml";
    in
    {
      config.sops.secrets = lib.pipe config.vars.filteredEmailAccounts [
        builtins.attrNames
        (map (
          account:
          lib.nameValuePair "email-passwords/${account}" {
            sopsFile = commonSecrets;
          }
        ))
        builtins.listToAttrs
      ];
    };
}
