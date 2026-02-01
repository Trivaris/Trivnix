{
  config,
  lib,
  ...
}:
{
  options.vars.filteredEmailAccounts = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    default = lib.filterAttrs (
      accountName: _: !(builtins.elem accountName config.userPrefs.email.exclude)
    ) config.private.emailAccounts.${config.userInfos.name};
  };
}
