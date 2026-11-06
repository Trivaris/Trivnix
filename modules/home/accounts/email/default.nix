{
  imports = [
    ./options.nix
    ./secrets.nix
    ./vars.nix
  ];

  flake.homeModules.accounts-email =
    {
      config,
      lib,
      ...
    }:
    let
      email-prefs = config.user-prefs.email;
      thunderbird-prefs = config.user-prefs.thunderbird;

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
      config = lib.mkIf email-prefs.enable {
        accounts.email.accounts = lib.mapAttrs (
          accountName: account:
          (
            {
              passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
              thunderbird = lib.mkIf (thunderbird-prefs.enable && email-prefs.enableThunderbirdIntegration) {
                enable = true;
                profiles = [ config.user-infos.name ];
              };
            }
            // account
          )
        ) config.vars.filtered-email-accounts;

        xdg.configFile = lib.mkIf email-prefs.generateAccountsFile {
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
