{
  inputs,
  userInfos,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    pipe
    types
    ;
in
{
  options.userPrefs.email = {
    enable = mkEnableOption ''
      Turn on SOPS-backed email account provisioning for this user.
      When enabled, mail settings and secrets sync from trivnixPrivate.
    '';

    exclude = mkOption {
      type = pipe inputs.trivnixPrivate.emailAccounts.${userInfos.name} or { } [
        builtins.attrNames
        types.enum
        types.listOf
      ];

      default = [ ];
      description = ''
        Email account identifiers to ignore when provisioning profiles.
        Filter names listed under `inputs.trivnixPrivate.emailAccounts.<user>`.
      '';
    };

    generateAccountsFile = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Control whether a JSON summary of filtered accounts is written.
        Set to false when an external tool manages `mailaccounts.json`.
      '';
    };

    enableThunderbirdIntegration = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Allow this module to auto-configure Thunderbird profiles from secrets.
        Disable if you prefer to manage Thunderbird settings manually.
      '';
    };
  };
}
