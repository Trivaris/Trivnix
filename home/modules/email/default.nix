{
  inputs,
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.userPrefs;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf prefs.email.enable {
    accounts.email.accounts = lib.mapAttrs' (
      accountName: account:
      lib.nameValuePair accountName (
        {
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          thunderbird = mkIf (builtins.elem "thunderbird" prefs.desktopApps) {
            enable = true;
            profiles = [ userInfos.name ];
          };
        }
        // account
      )
    ) inputs.trivnix-private.emailAccounts;
  };
}
