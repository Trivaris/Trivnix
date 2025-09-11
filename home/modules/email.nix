{
  config,
  lib,
  inputs,
  userInfos,
  ...
}:
let
  inherit (inputs.trivnix-private) emailAccounts;
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    pipe
    ;

  hasPrivate = inputs ? trivnix-private;
  prefs = config.userPrefs;

  hasEmail =
    hasPrivate
    && (inputs.trivnix-private ? emailAccounts)
    && builtins.isAttrs inputs.trivnix-private.emailAccounts;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf prefs.email.enable {
    assertions = [
      {
        assertion = (!prefs.email.enable) || hasPrivate;
        message = ''Email module enabled but input "trivnix-private" is missing. See docs/trivnix-private.md.'';
      }
      {
        assertion = (!prefs.email.enable) || hasEmail;
        message = ''Email module enabled but inputs.trivnix-private.emailAccounts is missing or not an attrset.'';
      }
    ];

    accounts.email.accounts = pipe emailAccounts [
      (mapAttrs' (
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
      ))
    ];

    home.file.".config/mailaccounts.json".text = pipe emailAccounts [
      (mapAttrs' (
        accountName: account:
        nameValuePair accountName {
          inherit (account.imap.tls) useStartTls;
          inherit (account.imap) host port;

          username = account.userName;
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
        }
      ))
      builtins.toJSON
    ];
  };
}
