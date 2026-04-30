{
  lib,
  config,
  ...
}:
{
  config.sops.secrets = lib.pipe config.vars.filteredEmailAccounts [
    builtins.attrNames
    (map (account: lib.nameValuePair "email-passwords/${account}" { }))
    builtins.listToAttrs
  ];
}