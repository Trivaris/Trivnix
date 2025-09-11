{
  config,
  lib,
  inputs,
  userInfos,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    ;
  inherit (inputs.trivnix-private) emailAccounts;
  prefs = config.userPrefs;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf prefs.email.enable {
    accounts.email.accounts =
      emailAccounts
      |> mapAttrs' (
        accountName: account:
        nameValuePair accountName (
          {
            passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
            thunderbird = mkIf (builtins.elem "thunderbird" prefs.gui) {
              enable = true;
              profiles = [ userInfos.name ];
            };
          }
          // account
        )
      );

    home.file.".config/mailaccounts.json".text =
      emailAccounts
      |> mapAttrs' (
        accountName: account:
        nameValuePair accountName {
          inherit (account.imap.tls) useStartTls;
          inherit (account.imap) host port;

          username = account.userName;
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
        }
      )
      |> builtins.toJSON;
  };
}
