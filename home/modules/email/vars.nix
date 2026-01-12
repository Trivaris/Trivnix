{
  config,
  lib,
  ...
}:
{
  options.vars.filteredEmailAccounts = lib.mkOption {
    type = lib.types.attrs;

    default = lib.filterAttrs (
      accountName: _: !(builtins.elem accountName config.userPrefs.email.exclude)
    ) config.private.emailAccounts.${config.userInfos.name};

    description = ''
      Derived set of email accounts after applying the `exclude` filter.
      Downstream modules reuse this attrset for secrets and application configs.
    '';
  };
}
