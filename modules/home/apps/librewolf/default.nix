{
  flake.homeModules.apps-librewolf =
    {
      config,
      osConfig,
      lib,
      pkgs,
      ...
    }:
    let
      librewolf-prefs = config.user-prefs.librewolf;
      # scheme = osConfig.theme-prefs.scheme;

      overrides = ''
        /** OVERRIDES ***/
        user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
        user_pref("places.history.enabled", false);
        user_pref("sidebar.revamp", true);
        user_pref("sidebar.verticalTabs", true);
      '';

      betterfox = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yokoffing/betterfox/a9b4b8803aebd3a87492f0936db5a3c8513ae522/user.js";
        sha256 = "sha256-Xo3NJ8BL/Px0neuYagxZpdKc3qRA0M3q95fKMNu8ruE=";
      };

      smoothfox = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/yokoffing/betterfox/a9b4b8803aebd3a87492f0936db5a3c8513ae522/smoothfox.js";
        sha256 = "sha256-S1zDXctpV1jNlV9DCua4fYMHfR7T34V3gQi780ShFpk=";
      };
    in
    {
      config = lib.mkIf librewolf-prefs.enable {
        home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

        home.file = {
          ".librewolf/${config.home.username}/search.json.mozlz4".force = lib.mkForce true;

          ".librewolf/${config.home.username}/user.js".text =
            builtins.readFile betterfox + " \n" + builtins.readFile smoothfox + " \n" + overrides;

          # ".librewolf/${config.home.username}/chrome/userChrome.css".text = ''
          #   :root {
          #     --lwt-accent-color: ${theme.base00} !important;
          #     --lwt-text-color: ${theme.base05} !important;
          #     --toolbar-bgcolor: ${theme.base00} !important;
          #     --toolbar-color: ${theme.base05} !important;
          #     --tab-selected-bgcolor: ${theme.base01} !important;
          #   }
          # '';
          # ".librewolf/${config.home.username}/chrome/userContent.css".text = ''
          #   body {
          #     background: transparent !important;
          #   }
          # '';
        };

        programs.librewolf = {
          enable = true;
          package = pkgs.librewolf-bin;

          profiles.${config.home.username} = {
            isDefault = true;

            search = {
              default = "brave";
              order = [
                "brave"
                "mynixos"
                "nixos-search"
              ];

              engines = {
                brave = {
                  name = "Brave";
                  urls = [
                    {
                      template = "https://search.brave.com/search";
                      params = [ (lib.nameValuePair "q" "{searchTerms}") ];
                    }
                  ];
                };

                mynixos = {
                  name = "MyNixOS";
                  definedAliases = [ "@mn" ];
                  urls = [
                    {
                      template = "https://mynixos.com/search";
                      params = [ (lib.nameValuePair "q" "{searchTerms}") ];
                    }
                  ];
                };

                nixos-search = {
                  name = "Nix Packages";
                  definedAliases = [ "@np" ];
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        (lib.nameValuePair "channel" osConfig.host-infos.stateVersion)
                        (lib.nameValuePair "query" "{searchTerms}")
                      ];
                    }
                  ];
                };
              };
            };
          };

          # settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            Cookies.Allow = librewolf-prefs.allowedCookies;

            SanitizeOnShutdown = {
              cache = true;
              cookies = true;
              downloads = true;
              formdata = true;
              history = true;
              passwords = true;
              sessions = true;
              siteSettings = true;
              offlineApps = true;
            };
          };
        };
      };
    };
}
