{
  lib,
  config,
  ...
}:
let 
  commonSecrets = "${config.private.secrets}/home/${config.userInfos.name}/common.yaml";
in 
{
  config.sops.secrets = lib.pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: lib.nameValuePair "email-passwords/${account}" {
      sopsFile = commonSecrets;
    }))
    builtins.listToAttrs
  ];
}
