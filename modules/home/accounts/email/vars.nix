{
  flake.homeModules.accounts-email =
    {
      config,
      lib,
      ...
    }:
    {
      options.vars.filteredEmailAccounts = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        default =
          if !config ? private then
            { }
          else
            lib.filterAttrs (
              accountName: _: !(builtins.elem accountName config.user.preferences.email.exclude)
            ) config.private.emailAccounts or { };
        description = ''
          Email accounts after applying `user.preferences.email.exclude`.
          This derived value is consumed by account and Thunderbird configuration.
        '';
      };
    };
}
