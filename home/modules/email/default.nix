{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.email.enable = mkEnableOption "Enable Email Accounts";

  config = mkIf cfg.email.enable {
    accounts.email.accounts = inputs.trivnix-private.emailAccounts;
  };
}