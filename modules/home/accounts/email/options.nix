{
  flake.homeModules.accounts-email =
    {
      config,
      lib,
      ...
    }:
    let
      tlsSubmodule = lib.types.submodule {
        options = {
          useStartTls = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to use StartTLS.";
          };
        };
      };

      serverSubmodule = lib.types.submodule {
        options = {
          host = lib.mkOption {
            type = lib.types.str;
            description = "Server hostname.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = "Server port.";
          };
          tls = lib.mkOption {
            type = tlsSubmodule;
            default = { };
            description = "TLS configuration.";
          };
        };
      };

      accountSubmodule = lib.types.submodule {
        options = {
          address = lib.mkOption {
            type = lib.types.str;
            description = "Email address.";
          };
          realName = lib.mkOption {
            type = lib.types.str;
            description = "Real name of the account owner.";
          };
          userName = lib.mkOption {
            type = lib.types.str;
            description = "Login username.";
          };
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this is the primary account.";
          };
          imap = lib.mkOption {
            type = serverSubmodule;
            description = "IMAP server configuration.";
          };
          smtp = lib.mkOption {
            type = serverSubmodule;
            description = "SMTP server configuration.";
          };
        };
      };

      calendarSubmodule = lib.types.submodule {
        options = {
          uri = lib.mkOption {
            type = lib.types.str;
            description = "URI for the calendar.";
          };
          username = lib.mkOption {
            type = lib.types.str;
            description = "Username for authentication.";
          };
          uuid = lib.mkOption {
            type = lib.types.str;
            description = "Unique ID for the calendar.";
          };
          color = lib.mkOption {
            type = lib.types.str;
            default = "#ffffff";
            description = "Display color for the calendar.";
          };
        };
      };
    in
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

      options.private.calendarAccounts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf calendarSubmodule);
        default = { };
        description = "Calendar accounts per user.";
      };

      options.private.emailAccounts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf accountSubmodule);
        default = { };
        description = "Email accounts per user.";
      };
    };
}
