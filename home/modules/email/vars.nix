{
  config,
  inputs,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkOption
    filterAttrs
    types
    ;
in
{
  options.vars.filteredEmailAccounts = mkOption {
    type = types.attrs;

    default = filterAttrs (
      accountName: _: !(builtins.elem accountName config.userPrefs.email.exclude)
    ) (inputs.trivnixPrivate.emailAccounts.${userInfos.name} or { });

    description = ''
      Derived set of email accounts after applying the `exclude` filter.
      Downstream modules reuse this attrset for secrets and application configs.
    '';
  };
}
