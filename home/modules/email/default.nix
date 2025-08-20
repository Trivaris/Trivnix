{
  inputs,
  config,
  lib,
  userInfos,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userPrefs;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf cfg.email.enable {
    accounts.email.accounts = lib.mapAttrs' (accountName: account:
      lib.nameValuePair
        accountName
        ({
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          thunderbird = mkIf (builtins.elem "thunderbird" cfg.desktopApps) {
            enable = true;
            profiles = [ userInfos.name ];
          };
        } // account)
      ) inputs.trivnix-private.emailAccounts;
  };
}
