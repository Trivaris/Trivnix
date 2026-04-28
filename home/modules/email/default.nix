{
  config,
  lib,
  ...
}:
let
  emailPrefs = config.userPrefs.email;
  thunderbirdPrefs = config.userPrefs.thunderbird;

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
  config = lib.mkIf emailPrefs.enable {
    accounts.email.accounts = lib.mapAttrs (
      accountName: account:
      (
        {
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          thunderbird = lib.mkIf (thunderbirdPrefs.enable && emailPrefs.enableThunderbirdIntegration) {
            enable = true;
            profiles = [ config.userInfos.name ];
          };
        }
        // account
      )
    ) config.vars.filteredEmailAccounts;

    home.file = lib.mkIf emailPrefs.generateAccountsFile {
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
