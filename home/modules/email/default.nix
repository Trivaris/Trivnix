{
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkIf mapAttrs' nameValuePair;
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
  config = mkIf prefs.email.enable {
    accounts.email.accounts = mapAttrs' (
      accountName: account:
      nameValuePair accountName (
        {
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          thunderbird = mkIf (prefs.thunderbird.enable && prefs.email.enableThunderbirdIntegration) {
            enable = true;
            profiles = [ userInfos.name ];
          };
        }
        // account
      )
    ) config.vars.filteredEmailAccounts;

    home.file = mkIf prefs.email.generateAccountsFile {
      ".config/mailaccounts.json".text = builtins.toJSON (
        mapAttrs' (
          accountName: account:
          let
            imap = account.imap or { };
            tls = imap.tls or { };
            tlsEnabled = tls.enable || tls.useStartTls;
            useStartTls = tls.useStartTls or false;
            security = getSecurity tlsEnabled useStartTls;
            computedAddress = if (account.address or "") != "" then account.address else account.userName or "";
          in
          nameValuePair accountName {
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
