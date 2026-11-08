{
  flake.homeModules.accounts-email =
    {
      config,
      lib,
      ...
    }:
    let
      emailPreferences = config.user.preferences.email;
      thunderbirdPreferences = config.user.preferences.thunderbird;

      getSecurity =
        tlsEnabled: useStartTls:
        if !tlsEnabled then
          "plain"
        else if useStartTls then
          "starttls"
        else
          "ssl";
    in
    {
      config = lib.mkIf emailPreferences.enable {
        accounts.email.accounts = lib.mapAttrs (
          accountName: account:
          (
            {
              passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
              thunderbird =
                lib.mkIf (thunderbirdPreferences.enable && emailPreferences.enableThunderbirdIntegration)
                  {
                    enable = true;
                    profiles = [ config.home.username ];
                  };
            }
            // account
          )
        ) config.vars.filteredEmailAccounts;

        xdg.configFile = lib.mkIf emailPreferences.generateAccountsFile {
          "mailaccounts.json".text = builtins.toJSON (
            lib.mapAttrs (
              accountName: account:
              let
                imap = account.imap or { };
                tls = imap.tls or { };
                tlsEnabled = tls.enable || tls.useStartTls;
                useStartTls = tls.useStartTls or false;
                security = getSecurity tlsEnabled useStartTls;
                computedAddress = if (account.address or "") != "" then account.address else account.userName or "";
              in
              {
                inherit (imap) host port;
                inherit useStartTls security;

                address = computedAddress;
                username = account.userName;
                passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
              }
            ) config.accounts.email.accounts
          );
        };
      };
    };
}
