{
  config,
  lib,
  ...
}:
{
  options.userPrefs.email = {
    enable = lib.mkEnableOption ''
      Turn on SOPS-backed email account provisioning for this user.
      When enabled, mail settings and secrets sync from trivnixPrivate.
    '';

    exclude = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum (builtins.attrNames config.private.emailAccounts.${config.userInfos.name} or { })
      );

      default = [ ];
      description = ''
        Email account identifiers to ignore when provisioning profiles.
        Filter names listed under `config.private.emailAccounts.<user>`.
      '';
    };

    generateAccountsFile = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Control whether a JSON summary of filtered accounts is written.
        Set to false when an external tool manages `mailaccounts.json`.
      '';
    };

    enableThunderbirdIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Allow this module to auto-configure Thunderbird profiles from secrets.
        Disable if you prefer to manage Thunderbird settings manually.
      '';
    };
  };
}
