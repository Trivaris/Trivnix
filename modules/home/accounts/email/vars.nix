{
  flake.homeModules.accounts-email =
    {
      config,
      lib,
      ...
    }:
    {
      options.vars.filtered-email-accounts = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        default =
          if !config ? private then
            { }
          else
            lib.filterAttrs (
              accountName: _: !(builtins.elem accountName config.user-prefs.email.exclude)
            ) config.private.email-accounts or { };
        description = ''
          Email accounts after applying `user-prefs.email.exclude`.
          This derived value is consumed by account and Thunderbird configuration.
        '';
      };
    };
}
