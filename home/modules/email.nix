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
    mkOption
    mkIf
    mapAttrs'
    nameValuePair
    pipe
    types
    filterAttrs
    ;

  hasPrivate = inputs ? trivnixPrivate;
  prefs = config.userPrefs;

  hasEmail =
    hasPrivate
    && (inputs.trivnixPrivate ? emailAccounts)
    && builtins.isAttrs inputs.trivnixPrivate.emailAccounts;
in
{
  options = {
    userPrefs.email = {
      enable = mkEnableOption ''
        Turn on SOPS-backed email account provisioning for this user.
        When enabled, mail settings and secrets sync from trivnixPrivate.
      '';

      exclude = mkOption {
        type = pipe emailAccounts.${userInfos.name} or { } [
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

    vars.filteredEmailAccounts = mkOption {
      type = types.attrs;

      default = filterAttrs (accountName: _: !(builtins.elem accountName prefs.email.exclude)) (
        emailAccounts.${userInfos.name} or { }
      );

      description = ''
        Derived set of email accounts after applying the `exclude` filter.
        Downstream modules reuse this attrset for secrets and application configs.
      '';
    };
  };

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
          thunderbird =
            mkIf (builtins.elem "thunderbird" prefs.gui && prefs.email.enableThunderbirdIntegration)
              {
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
            security =
              if !tlsEnabled then
                "plain"
              else if useStartTls then
                "starttls"
              else
                "ssl";
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
