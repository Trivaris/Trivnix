{
  inputs,
  config,
  lib,
  userPrefs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userPrefs;
in
{
  options.userPrefs.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf cfg.email.enable {
    accounts.email.accounts = builtins.listToAttrs (
      map (
        accountName:
        let
          account = inputs.trivnix-private.emailAccounts.${accountName};
        in
        {
          name = accountName;
          value = account // {
            passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
            thunderbird = mkIf (builtins.elem "thunderbird" cfg.desktopApps) {
              enable = true;
              profiles = [ userPrefs.name ];
            };
          };
        }
      ) (builtins.attrNames inputs.trivnix-private.emailAccounts)
    );
  };
}
