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
      enable = mkEnableOption "Enable Email Accounts";
      exclude = mkOption {
        type = pipe emailAccounts.${userInfos.name} or { } [
          builtins.attrNames
          types.enum
          types.listOf
        ];
        default = [ ];
        description = "Mail accounts to omit";
      };
    };

    vars.filteredEmailAccounts = mkOption {
      type = types.attrs;
      default = (
        filterAttrs (accountName: _: !(builtins.elem accountName prefs.email.exclude)) (
          emailAccounts.${userInfos.name} or { }
        )
      );
      description = "Email accounts, but filtered. Set automatically";
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
          thunderbird = mkIf (builtins.elem "thunderbird" prefs.gui) {
            enable = true;
            profiles = [ userInfos.name ];
          };
        }
        // account
      )
    ) config.vars.filteredEmailAccounts;

    home.file.".config/mailaccounts.json".text = pipe config.vars.filteredEmailAccounts [
      (mapAttrs' (
        accountName: account:
        let
          imap = account.imap or { };
          tls = imap.tls or { };
          tlsEnabled =
            (tls.enable or false)
            || (tls.useStartTls or false)
            || (builtins.length (builtins.attrNames tls) > 0);
          useStartTls = tls.useStartTls or false;
          security =
            if !tlsEnabled then
              "plain"
            else if useStartTls then
              "starttls"
            else
              "ssl";
        in
        nameValuePair accountName {
          inherit (imap) host port;
          username = account.userName;
          passwordCommand = "cat ${config.sops.secrets."email-passwords/${accountName}".path}";
          inherit useStartTls security;
        }
      ))
      builtins.toJSON
    ];
  };
}
