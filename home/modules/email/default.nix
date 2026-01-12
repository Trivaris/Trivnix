{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;

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
  config = lib.mkIf prefs.email.enable {
    accounts.email.accounts = lib.mapAttrs (
      accountName: account:
      (
        {
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          thunderbird = lib.mkIf (prefs.thunderbird.enable && prefs.email.enableThunderbirdIntegration) {
            enable = true;
            profiles = [ config.userInfos.name ];
          };
        }
        // account
      )
    ) config.vars.filteredEmailAccounts;

    home.file = lib.mkIf prefs.email.generateAccountsFile {
      ".config/mailaccounts.json".text = builtins.toJSON (
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
}
