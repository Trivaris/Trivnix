{
  config,
  lib,
  ...
}:
{
  options.vars.filteredEmailAccounts = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    default = if !config ? private then {} else lib.filterAttrs (
      accountName: _: !(builtins.elem accountName config.userPrefs.email.exclude)
    ) config.private.emailAccounts.${config.userInfos.name};
    description = ''
      Email accounts after applying `userPrefs.email.exclude`.
      This derived value is consumed by account and Thunderbird configuration.
    '';
  };
}
