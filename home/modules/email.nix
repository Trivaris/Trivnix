{
  config,
  lib,
  inputs,
  userInfos,
  ...
}:
let
  inherit (inputs.trivnixPrivate) emailAccounts;
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    pipe
    ;

  hasPrivate = inputs ? trivnixPrivate;
  prefs = config.userPrefs;

  hasEmail =
    hasPrivate
    && (inputs.trivnixPrivate ? emailAccounts)
    && builtins.isAttrs inputs.trivnixPrivate.emailAccounts;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf prefs.email.enable {
    assertions = [
      {
        assertion = prefs.email.enable -> hasPrivate;
        message = ''Email module enabled but input "trivnixPrivate" is missing. See docs/trivnix-private.md.'';
      }
      {
        assertion = prefs.email.enable -> hasEmail;
        message = ''Email module enabled but inputs.trivnixPrivate.emailAccounts is missing or not an attrset.'';
      }
    ];

    accounts.email.accounts = mapAttrs' (
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
    ) emailAccounts.${userInfos.name};

    home.file.".config/mailaccounts.json".text = pipe emailAccounts.${userInfos.name} [
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
